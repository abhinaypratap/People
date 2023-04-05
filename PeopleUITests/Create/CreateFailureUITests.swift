import XCTest

final class CreateFailureUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launchEnvironment = [
            "-people-networking-success": "1",
            "-create-networking-success": "0"
        ]
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    func testAlertIsShownWhenSubmissionFails() {

        let createBtn = app.buttons["createBtn"]
        XCTAssertTrue(createBtn.waitForExistence(timeout: 5), "The create button should be visible on the screen")

        createBtn.tap()

        let firstnameTxtField = app.textFields["firstNameTxtField"]
        let lastnameTxtField = app.textFields["lastNameTxtField"]
        let jobTxtField = app.textFields["jobTxtField"]

        firstnameTxtField.tap()
        firstnameTxtField.typeText("Tunds")

        lastnameTxtField.tap()
        lastnameTxtField.typeText("Ads")

        jobTxtField.tap()
        jobTxtField.typeText("iOS Developer")

        let submitBtn = app.buttons["submitBtn"]
        XCTAssertTrue(submitBtn.exists, "The submit button should be visible on the screen")

        submitBtn.tap()

        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5))

        XCTAssertTrue(alert.staticTexts["URL isn't valid"].exists)
        XCTAssertTrue(alert.buttons["OK"].exists)
    }
}
