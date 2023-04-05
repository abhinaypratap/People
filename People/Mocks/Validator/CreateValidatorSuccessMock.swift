#if DEBUG
import Foundation

struct CreateValidatorSuccessMock: CreateValidatorProtocol {

    func validate(_ person: NewPerson) throws {}
}
#endif
