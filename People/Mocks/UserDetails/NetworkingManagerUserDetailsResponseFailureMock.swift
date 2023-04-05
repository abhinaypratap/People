#if DEBUG
import Foundation

// swiftlint:disable:next type_name
class NetworkingManagerUserDetailsResponseFailureMock: NetworkingManagerProtocol {

    func request<T>(session: URLSession, _ endpoint: Endpoint, type: T.Type) async throws -> T where T: Decodable {
        throw NetworkingManager.NetworkingError.invalidUrl
    }

    func request(session: URLSession, _ endpoint: Endpoint) async throws {}
}
#endif
