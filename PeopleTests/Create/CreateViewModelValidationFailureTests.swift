import XCTest
@testable import People

final class CreateViewModelValidationFailureTests: XCTestCase {

    private var networkingMock: NetworkingManagerProtocol!
    private var validationMock: CreateValidatorProtocol!
    private var createViewModel: CreateViewModel!

    override func setUp() {
        networkingMock = NetworkingManagerCreateSuccessMock()
        validationMock = CreateValidatorFailureMock()
        createViewModel = CreateViewModel(networkingManager: networkingMock, validator: validationMock)
    }

    override func tearDown() {
        networkingMock = nil
        validationMock = nil
        createViewModel = nil
    }

    func testWithInvalidFormSubmissionStateIsInvalid() async {

        XCTAssertNil(createViewModel.state, "The view model should be nil initially")
        defer { XCTAssertEqual(createViewModel.state, .unsuccessful, "The view model state should be unsuccessful") }

        await createViewModel.create()

        XCTAssertTrue(createViewModel.hasError, "The view model should have an error")
        XCTAssertNotNil(createViewModel.error, "The view model error property shouldn't be nil")
        XCTAssertEqual(
            createViewModel.error,
            .validation(error: CreateValidator.CreateValidatorError.invalidFirstName),
            "The view model error should be invalid first name"
        )
    }
}
