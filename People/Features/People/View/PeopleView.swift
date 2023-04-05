import SwiftUI

struct PeopleView: View {

    private let columns = Array(repeating: GridItem(.flexible()), count: 2)

    @StateObject private var peopleViewModel: PeopleViewModel
    @State private var shouldShowCreate = false
    @State private var shouldShowSuccess = false
    @State private var hasAppeared = false

    init() {
#if DEBUG
        if UITestingHelper.isUITesting {
            let mock: NetworkingManagerProtocol = UITestingHelper.isPeopleNetworkingSuccessful
            ? NetworkingManagerUserResponseSuccessMock()
            : NetworkingManagerUserResponseFailureMock()
            _peopleViewModel = StateObject(wrappedValue: PeopleViewModel(networkingManager: mock))
        } else {
            _peopleViewModel = StateObject(wrappedValue: PeopleViewModel())
        }
#else
        _vm = StateObject(wrappedValue: PeopleViewModel())
#endif
    }

    var body: some View {
        ZStack {

            background

            if peopleViewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(peopleViewModel.users, id: \.id) { user in
                            NavigationLink {
                                DetailView(userId: user.id)
                            } label: {
                                PersonItemView(user: user)
                                    .accessibilityIdentifier("item_\(user.id)")
                                    .task {
                                        if peopleViewModel.hasReachedEnd(of: user) && !peopleViewModel.isFetching {
                                            await peopleViewModel.fetchNextSetOfUsers()
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                    .accessibilityIdentifier("peopleGrid")
                }
                .refreshable {
                    await peopleViewModel.fetchUsers()
                }
                .overlay(alignment: .bottom) {
                    if peopleViewModel.isFetching {
                        ProgressView()
                    }
                }
            }
        }
        .navigationTitle("People")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                create
            }
            ToolbarItem(placement: .navigationBarLeading) {
                refresh
            }
        }
        .task {
            if !hasAppeared {
                await peopleViewModel.fetchUsers()
                hasAppeared = true
            }
        }
        .sheet(isPresented: $shouldShowCreate) {
                        CreateView {
                            haptic(.success)
                            withAnimation(.spring().delay(0.25)) {
                                self.shouldShowSuccess.toggle()
                            }
                        }
        }
        .alert(isPresented: $peopleViewModel.hasError, error: peopleViewModel.error) {
            Button("Retry") {
                Task {
                    await peopleViewModel.fetchUsers()
                }
            }
        }
        .overlay {
            if shouldShowSuccess {
                CheckmarkPopoverView()
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.spring().delay(2)) {
                                self.shouldShowSuccess.toggle()
                            }
                        }
                    }
            }
        }
        .embedInNavigation()
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}

private extension PeopleView {

    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }

    var create: some View {
        Button {
            shouldShowCreate.toggle()
        } label: {
            Symbols.plus
                .font(
                    .system(.headline, design: .rounded)
                    .bold()
                )
        }
        .disabled(peopleViewModel.isLoading)
        .accessibilityIdentifier("createBtn")
    }

    var refresh: some View {
        Button {
            Task {
                await peopleViewModel.fetchUsers()
            }
        } label: {
            Symbols.refresh
        }
        .disabled(peopleViewModel.isLoading)
    }
}
