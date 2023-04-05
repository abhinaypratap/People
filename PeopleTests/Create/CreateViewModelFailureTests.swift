import XCTest
@testable import People

final class CreateViewModelFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerProtocol!
    private var validationMock: CreateValidatorProtocol!
    private var createViewModel: CreateViewModel!

    override func setUp() {
        networkingMock = NetworkingManagerCreateFailureMock()
        validationMock = CreateValidatorSuccessMock()
        createViewModel = CreateViewModel(networkingManager: networkingMock, validator: validationMock)
    }

    override func tearDown() {
        networkingMock = nil
        validationMock = nil
        createViewModel = nil
    }

    func testWithUnsuccessfulResponseSubmissionStateIsUnsuccessful() async throws {

        XCTAssertNil(createViewModel.state, "The view model state should be nil")
        defer { XCTAssertEqual(createViewModel.state, .unsuccessful, "The view model state should be unsuccessful") }

        await createViewModel.create()

        XCTAssertTrue(createViewModel.hasError, "The view model should have an error")
        XCTAssertNotNil(createViewModel.error, "The view model error shouldn't be nil")
        XCTAssertEqual(
            createViewModel.error,
            .networking(error: NetworkingManager.NetworkingError.invalidUrl),
            "The view model error should be a networking error with an invalid url"
        )
    }
}
