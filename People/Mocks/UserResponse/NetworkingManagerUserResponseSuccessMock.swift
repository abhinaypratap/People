#if DEBUG
import Foundation

class NetworkingManagerUserResponseSuccessMock: NetworkingManagerProtocol {

    func request<T>(
        session: URLSession,
        _ endpoint: Endpoint,
        type: T.Type
    ) async throws -> T where T: Decodable, T: Encodable {
        // swiftlint:disable:next force_cast
        return try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self) as! T
    }

    func request(session: URLSession, _ endpoint: Endpoint) async throws { }
}
#endif
