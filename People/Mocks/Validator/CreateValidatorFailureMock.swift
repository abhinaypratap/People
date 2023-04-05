#if DEBUG
import Foundation

struct CreateValidatorFailureMock: CreateValidatorProtocol {

    func validate(_ person: NewPerson) throws {
        throw CreateValidator.CreateValidatorError.invalidFirstName
    }
}
#endif
