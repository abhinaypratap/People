import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @StateObject private var createViewModel: CreateViewModel

    private let successfulAction: () -> Void
    init(successfulAction: @escaping () -> Void) {
        self.successfulAction = successfulAction

#if DEBUG
        if UITestingHelper.isUITesting {
            let mock: NetworkingManagerProtocol = UITestingHelper.isCreateNetworkingSuccessful
            ? NetworkingManagerCreateSuccessMock()
            : NetworkingManagerCreateFailureMock()
            _createViewModel = StateObject(wrappedValue: CreateViewModel(networkingManager: mock))
        } else {
            _createViewModel = StateObject(wrappedValue: CreateViewModel())
        }
#else
        _vm = StateObject(wrappedValue: CreateViewModel())
#endif
    }

    var body: some View {
        Form {
            Section {
                firstname
                lastname
                job
            } footer: {
                if case .validation(let err) = createViewModel.error,
                   let errorDesc = err.errorDescription {
                    Text(errorDesc)
                        .foregroundStyle(.red)
                }
            }
            Section {
                submit
            }
        }
        .disabled(createViewModel.state == .submitting)
        .navigationTitle("Create")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                done
            }
        }
        .onChange(of: createViewModel.state) { formState in
            if formState == .successful {
                dismiss()
                successfulAction()
            }
        }
        .alert(isPresented: $createViewModel.hasError, error: createViewModel.error) { }
        .overlay {
            if createViewModel.state == .submitting {
                ProgressView()
            }
        }
        .embedInNavigation()
    }
}

extension CreateView {
    enum Field: Hashable {
        case firstName
        case lastName
        case job
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView {}
    }
}

private extension CreateView {
    var done: some View {
        Button("Done") {
            dismiss()
        }
        .accessibilityIdentifier("doneBtn")
    }

    var firstname: some View {
        TextField("First name", text: $createViewModel.person.firstName)
            .focused($focusedField, equals: .firstName)
            .accessibilityIdentifier("firstNameTxtField")
    }

    var lastname: some View {
        TextField("Last name", text: $createViewModel.person.lastName)
            .focused($focusedField, equals: .lastName)
            .accessibilityIdentifier("lastNameTxtField")
    }

    var job: some View {
        TextField("Job", text: $createViewModel.person.job)
            .focused($focusedField, equals: .job)
            .accessibilityIdentifier("jobTxtField")
    }

    var submit: some View {
        Button("Submit") {
            focusedField = nil
            Task {
                await createViewModel.create()
            }
        }
        .accessibilityIdentifier("submitBtn")
    }
}
