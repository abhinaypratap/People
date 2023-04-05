#if DEBUG
import Foundation

class NetworkingManagerCreateSuccessMock: NetworkingManagerProtocol {

    func request<T>(session: URLSession, _ endpoint: Endpoint, type: T.Type) async throws -> T where T: Decodable {
        // swiftlint:disable:next force_cast
        return Data() as! T
    }

    func request(session: URLSession, _ endpoint: Endpoint) async throws {}
}
#endif
