import XCTest

final class CreateScreenFormValidationTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launchEnvironment = ["-people-networking-success": "1"]
        app.launch()
    }

    override func tearDown() {
        app = nil
    }

    func testWhenAllFormFieldsAreEmptyFirstNameErrorIsShown() {

        let createBtn = app.buttons["createBtn"]
        XCTAssertTrue(createBtn.waitForExistence(timeout: 5), "The create button should be visible on the screen")

        createBtn.tap()

        let submitBtn = app.buttons["submitBtn"]
        XCTAssertTrue(submitBtn.waitForExistence(timeout: 5), "The submit button should be visible on the screen")

        submitBtn.tap()

        let alert = app.alerts.firstMatch
        let alertBtn = alert.buttons.firstMatch

        XCTAssertTrue(alert.waitForExistence(timeout: 5), "There should be an alert on the screen")
        XCTAssertTrue(alert.staticTexts["First name can't be empty"].exists)
        XCTAssertEqual(alertBtn.label, "OK")

        alertBtn.tap()

        XCTAssertTrue(app.staticTexts["First name can't be empty"].exists)

        XCTAssertEqual(app.alerts.count, 0, "There should be no alerts on the screen")
    }

    func testWhenFirstNameFormFieldIsEmptyFirstNameErrorIsShown() {

        let createBtn = app.buttons["createBtn"]
        XCTAssertTrue(createBtn.waitForExistence(timeout: 5), "The create button should be visible on the screen")

        createBtn.tap()

        let lastnameTxtField = app.textFields["lastNameTxtField"]
        let jobTxtField = app.textFields["jobTxtField"]

        lastnameTxtField.tap()
        lastnameTxtField.typeText("Ads")

        jobTxtField.tap()
        jobTxtField.typeText("iOS Developer")

        let submitBtn = app.buttons["submitBtn"]
        XCTAssertTrue(submitBtn.waitForExistence(timeout: 5), "The submit button should be visible on the screen")

        submitBtn.tap()

        let alert = app.alerts.firstMatch
        let alertBtn = alert.buttons.firstMatch

        XCTAssertTrue(alert.waitForExistence(timeout: 5), "There should be an alert on the screen")
        XCTAssertTrue(alert.staticTexts["First name can't be empty"].exists)
        XCTAssertEqual(alertBtn.label, "OK")

        alertBtn.tap()

        XCTAssertTrue(app.staticTexts["First name can't be empty"].exists)

        XCTAssertEqual(app.alerts.count, 0, "There should be no alerts on the screen")
    }

    func testWhenLastNameFormFieldIsEmptyLastNameErrorIsShown() {

        let createBtn = app.buttons["createBtn"]
        XCTAssertTrue(createBtn.waitForExistence(timeout: 5), "The create button should be visible on the screen")

        createBtn.tap()

        let firstnameTxtField = app.textFields["firstNameTxtField"]
        let jobTxtField = app.textFields["jobTxtField"]

        firstnameTxtField.tap()
        firstnameTxtField.typeText("Tunds")

        jobTxtField.tap()
        jobTxtField.typeText("iOS Developer")

        let submitBtn = app.buttons["submitBtn"]
        XCTAssertTrue(submitBtn.waitForExistence(timeout: 5), "The submit button should be visible on the screen")

        submitBtn.tap()

        let alert = app.alerts.firstMatch
        let alertBtn = alert.buttons.firstMatch

        XCTAssertTrue(alert.waitForExistence(timeout: 5), "There should be an alert on the screen")
        XCTAssertTrue(alert.staticTexts["Last name can't be empty"].exists)
        XCTAssertEqual(alertBtn.label, "OK")

        alertBtn.tap()

        XCTAssertTrue(app.staticTexts["Last name can't be empty"].exists)

        XCTAssertEqual(app.alerts.count, 0, "There should be no alerts on the screen")
    }

    func testWhenJobFormFieldIsEmptyJobErrorIsShown() {

        let createBtn = app.buttons["createBtn"]
        XCTAssertTrue(createBtn.waitForExistence(timeout: 5), "The create button should be visible on the screen")

        createBtn.tap()

        let firstnameTxtField = app.textFields["firstNameTxtField"]
        let lastnameTxtField = app.textFields["lastNameTxtField"]

        firstnameTxtField.tap()
        firstnameTxtField.typeText("Tunds")

        lastnameTxtField.tap()
        lastnameTxtField.typeText("Ads")

        let submitBtn = app.buttons["submitBtn"]
        XCTAssertTrue(submitBtn.waitForExistence(timeout: 5), "The submit button should be visible on the screen")

        submitBtn.tap()

        let alert = app.alerts.firstMatch
        let alertBtn = alert.buttons.firstMatch

        XCTAssertTrue(alert.waitForExistence(timeout: 5), "There should be an alert on the screen")
        XCTAssertTrue(alert.staticTexts["Job can't be empty"].exists)
        XCTAssertEqual(alertBtn.label, "OK")

        alertBtn.tap()

        XCTAssertTrue(app.staticTexts["Job can't be empty"].exists)

        XCTAssertEqual(app.alerts.count, 0, "There should be no alerts on the screen")
    }
}
