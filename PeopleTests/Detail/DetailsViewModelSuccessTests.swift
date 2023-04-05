import XCTest
@testable import People

final class DetailsViewModelSuccessTests: XCTestCase {

    private var networkingMock: NetworkingManagerProtocol!
    private var detailViewModel: DetailViewModel!

    override func setUp() {
        networkingMock = NetworkingManagerUserDetailsResponseSuccessMock()
        detailViewModel = DetailViewModel(networkingManager: networkingMock)
    }

    override func tearDown() {
        networkingMock = nil
        detailViewModel = nil
    }

    func testWithUnsuccessfulResponseUsersDetailsIsSet() async throws {

        XCTAssertFalse(detailViewModel.isLoading, "The view model should not be loading")

        defer {
            XCTAssertFalse(detailViewModel.isLoading, "The view model should not be loading")
        }

        await detailViewModel.fetchDetails(for: 1)

        XCTAssertNotNil(detailViewModel.userInfo, "The user info in the view model should not be nil")

        let userDetailsData = try StaticJSONMapper.decode(file: "SingleUserData", type: UserDetailResponse.self)

        XCTAssertEqual(detailViewModel.userInfo, userDetailsData, "The response from our networking mock should match")
    }
}
