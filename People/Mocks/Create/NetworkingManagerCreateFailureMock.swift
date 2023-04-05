#if DEBUG
import Foundation

class NetworkingManagerCreateFailureMock: NetworkingManagerProtocol {

    func request<T>(session: URLSession, _ endpoint: Endpoint, type: T.Type) async throws -> T where T: Decodable {
        // swiftlint:disable:next force_cast
        return Data() as! T
    }

    func request(session: URLSession, _ endpoint: Endpoint) async throws {
        throw NetworkingManager.NetworkingError.invalidUrl
    }
}
#endif
