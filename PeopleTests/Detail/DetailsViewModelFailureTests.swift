import XCTest
@testable import People

final class DetailsViewModelFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerProtocol!
    private var detailViewModel: DetailViewModel!

    override func setUp() {
        networkingMock = NetworkingManagerUserDetailsResponseFailureMock()
        detailViewModel = DetailViewModel(networkingManager: networkingMock)
    }

    override func tearDown() {
        networkingMock = nil
        detailViewModel = nil
    }

    func testWithUnsuccessfulResponseErrorIsHandled() async {

        XCTAssertFalse(detailViewModel.isLoading, "The view model should not be loading")

        defer {
            XCTAssertFalse(detailViewModel.isLoading, "The view model should not be loading")
        }

        await detailViewModel.fetchDetails(for: 1)

        XCTAssertTrue(detailViewModel.hasError, "The view model error should be true")

        XCTAssertNotNil(detailViewModel.error, "The view model error should not be nil")
    }
}
