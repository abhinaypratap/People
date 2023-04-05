import SwiftUI

struct DetailView: View {

    let userId: Int
    @StateObject private var detailViewModel: DetailViewModel

    init(userId: Int) {
        self.userId = userId
#if DEBUG
        if UITestingHelper.isUITesting {
            let mock: NetworkingManagerProtocol = UITestingHelper.isDetailsNetworkingSuccessful
            ? NetworkingManagerUserDetailsResponseSuccessMock()
            : NetworkingManagerUserDetailsResponseFailureMock()
            _detailViewModel = StateObject(wrappedValue: DetailViewModel(networkingManager: mock))

        } else {
            _detailViewModel = StateObject(wrappedValue: DetailViewModel())
        }
#else
        _vm = StateObject(wrappedValue: DetailViewModel())
#endif
    }

    var body: some View {
        ZStack {
            background

            if detailViewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {

                    VStack(alignment: .leading, spacing: 18) {

                        avatar

                        Group {
                            general
                            link
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 18)
                        .background(Theme.detailBackground, in: RoundedRectangle(
                            cornerRadius: 16,
                            style: .continuous)
                        )

                    }
                           .padding()
                }
            }
        }
        .navigationTitle("Details")
        .task {
            await detailViewModel.fetchDetails(for: userId)
        }
        .alert(isPresented: $detailViewModel.hasError, error: detailViewModel.error) { }
    }
}

struct DetailView_Previews: PreviewProvider {

    private static var previewUserId: Int {
        // swiftlint:disable:next force_try
        let users = try! StaticJSONMapper.decode(
            file: "UsersStaticData",
            type: UsersResponse.self
        )
        return users.data.first!.id
    }

    static var previews: some View {
        DetailView(userId: previewUserId)
            .embedInNavigation()
    }
}

private extension DetailView {

    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }

    @ViewBuilder
    var avatar: some View {

        if let avatarAbsoluteString = detailViewModel.userInfo?.data.avatar,
           let avatarUrl = URL(string: avatarAbsoluteString) {

            AsyncImage(url: avatarUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

        }
    }

    @ViewBuilder
    var link: some View {

        if let supportAbsoluteString = detailViewModel.userInfo?.support.url,
           let supportUrl = URL(string: supportAbsoluteString),
           let supportTxt = detailViewModel.userInfo?.support.text {

            Link(destination: supportUrl) {

                VStack(alignment: .leading, spacing: 8) {

                    Text(supportTxt)
                        .foregroundColor(Theme.text)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .multilineTextAlignment(.leading)

                    Text(supportAbsoluteString)
                }

                Spacer()

                Symbols
                    .link
                    .font(.system(.title3, design: .rounded))
            }
        }
    }
}

private extension DetailView {

    var general: some View {
        VStack(alignment: .leading, spacing: 8) {

            PillView(id: detailViewModel.userInfo?.data.id ?? 0)

            Group {
                firstname
                lastname
                email
            }
            .foregroundColor(Theme.text)
        }
    }

    @ViewBuilder
    var firstname: some View {
        Text("First Name")
            .font(.system(.body, design: .rounded).weight(.semibold))

        Text(detailViewModel.userInfo?.data.firstName ?? "-")
            .font(.system(.subheadline, design: .rounded))

        Divider()
    }

    @ViewBuilder
    var lastname: some View {
        Text("Last Name")
            .font(.system(.body, design: .rounded).weight(.semibold))

        Text(detailViewModel.userInfo?.data.lastName ?? "-")
            .font(.system(.subheadline, design: .rounded))

        Divider()
    }

    @ViewBuilder
    var email: some View {
        Text("Email")
            .font(.system(.body, design: .rounded).weight(.semibold))

        Text(detailViewModel.userInfo?.data.email ?? "-")
            .font(.system(.subheadline, design: .rounded))
    }
}
