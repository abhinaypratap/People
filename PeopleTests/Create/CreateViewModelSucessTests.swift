import XCTest
@testable import People

final class CreateViewModelSucessTests: XCTestCase {

    private var networkingMock: NetworkingManagerProtocol!
    private var validationMock: CreateValidatorProtocol!
    private var createViewModel: CreateViewModel!

    override func setUp() {
        networkingMock = NetworkingManagerCreateSuccessMock()
        validationMock = CreateValidatorSuccessMock()
        createViewModel = CreateViewModel(networkingManager: networkingMock, validator: validationMock)
    }

    override func tearDown() {
        networkingMock = nil
        validationMock = nil
        createViewModel = nil
    }

    func testWithSuccessfulResponseSubmissionStateIsSuccessful() async throws {

        XCTAssertNil(createViewModel.state, "The view model state should be nil initially")

        defer { XCTAssertEqual(createViewModel.state, .successful, "The view model state should be successful") }

        await createViewModel.create()
    }
}
