import Foundation

struct User: Codable, Equatable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String
}
