import XCTest
@testable import People

final class PeopleViewModelSuccessTests: XCTestCase {

    private var networkingMock: NetworkingManagerProtocol!
    private var peopleViewModel: PeopleViewModel!

    override func setUp() {
        networkingMock = NetworkingManagerUserResponseSuccessMock()
        peopleViewModel = PeopleViewModel(networkingManager: networkingMock)
    }

    override func tearDown() {
        networkingMock = nil
        peopleViewModel = nil
    }

    func testWithSuccessfulResponseUsersArrayIsSet() async throws {

        XCTAssertFalse(peopleViewModel.isLoading, "The view model shouldn't be loading any data")
        defer {
            XCTAssertFalse(peopleViewModel.isLoading, "The view model shouldn't be loading any data")
            XCTAssertEqual(peopleViewModel.viewState, .finished, "The view model view state should be finished")
        }
        await peopleViewModel.fetchUsers()
        XCTAssertEqual(peopleViewModel.users.count, 6, "There should be 6 users within our data array")
    }

    func testWithSuccessfulPaginatedResponseUsersArrayIsSet() async throws {

        XCTAssertFalse(peopleViewModel.isLoading, "The view model shouldn't be loading any data")

        defer {
            XCTAssertFalse(peopleViewModel.isFetching, "The view model shouldn't be fetching any data")
            XCTAssertEqual(peopleViewModel.viewState, .finished, "The view model view state should be finished")
        }

        await peopleViewModel.fetchUsers()

        XCTAssertEqual(peopleViewModel.users.count, 6, "There should be 6 users within our data array")

        await peopleViewModel.fetchNextSetOfUsers()

        XCTAssertEqual(peopleViewModel.users.count, 12, "The should be 12 users within our data array")

        XCTAssertEqual(peopleViewModel.page, 2, "The page should be 2")

    }

    func testWithResetCalledValuesIsReset() async throws {

        defer {
            XCTAssertEqual(peopleViewModel.users.count, 6, "There should be 6 users within our data array")
            XCTAssertEqual(peopleViewModel.page, 1, "The page should be 1")
            XCTAssertEqual(peopleViewModel.totalPages, 2, "The total pages should be 2")
            XCTAssertEqual(peopleViewModel.viewState, .finished, "The view model view state should be finished")
            XCTAssertFalse(peopleViewModel.isLoading, "The view model shouldn't be loading any data")
        }

        await peopleViewModel.fetchUsers()

        XCTAssertEqual(peopleViewModel.users.count, 6, "There should be 6 users within our data array")

        await peopleViewModel.fetchNextSetOfUsers()

        XCTAssertEqual(peopleViewModel.users.count, 12, "The should be 12 users within our data array")

        XCTAssertEqual(peopleViewModel.page, 2, "The page should be 2")

        await peopleViewModel.fetchUsers()

    }

    func testWithLastUserFuncReturnsTrue() async {

        await peopleViewModel.fetchUsers()
        // swiftlint:disable:next force_try
        let userData = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)

        let hasReachedEnd = peopleViewModel.hasReachedEnd(of: userData.data.last!)

        XCTAssertTrue(hasReachedEnd, "The last user should match")
    }
}
