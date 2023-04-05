#if DEBUG
import Foundation

class NetworkingManagerUserResponseFailureMock: NetworkingManagerProtocol {

    func request<T>(
        session: URLSession,
        _ endpoint: Endpoint,
        type: T.Type
    ) async throws -> T where T: Decodable, T: Encodable {
        throw NetworkingManager.NetworkingError.invalidUrl
    }

    func request(session: URLSession, _ endpoint: Endpoint) async throws {}
}
#endif
