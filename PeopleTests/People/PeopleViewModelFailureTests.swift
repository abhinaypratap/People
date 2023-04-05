import XCTest
@testable import People

final class PeopleViewModelFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerProtocol!
    private var peopleViewModel: PeopleViewModel!

    override func setUp() {

        networkingMock = NetworkingManagerUserResponseFailureMock()
        peopleViewModel = PeopleViewModel(networkingManager: networkingMock)
    }

    override func tearDown() {
        networkingMock = nil
        peopleViewModel = nil
    }

    func testWithUnsuccessfulResponseErrorIsHandled() async {

        XCTAssertFalse(peopleViewModel.isLoading, "The view model shouldn't be loading any data")

        defer {
            XCTAssertFalse(peopleViewModel.isLoading, "The view model shouldn't be loading any data")
            XCTAssertEqual(peopleViewModel.viewState, .finished, "The view model view state should be finished")
        }

        await peopleViewModel.fetchUsers()

        XCTAssertTrue(peopleViewModel.hasError, "The view model should have an error")
        XCTAssertNotNil(peopleViewModel.error, "The view model error should be set")
    }
}
