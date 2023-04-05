#if DEBUG
import Foundation

// swiftlint:disable:next type_name
class NetworkingManagerUserDetailsResponseSuccessMock: NetworkingManagerProtocol {

    func request<T>(session: URLSession, _ endpoint: Endpoint, type: T.Type) async throws -> T where T: Decodable {
        // swiftlint:disable:next force_cast
        return try StaticJSONMapper.decode(file: "SingleUserData", type: UserDetailResponse.self) as! T
    }

    func request(session: URLSession, _ endpoint: Endpoint) async throws {}
}
#endif
