import XCTest
@testable import People

final class CreateFormValidatorTests: XCTestCase {

    private var validator: CreateValidator!

    override func setUp() {
        validator = CreateValidator()
    }

    override func tearDown() {
        validator = nil
    }

    func testWithEmptyPersonFirstNameErrorThrown() {
        let person = NewPerson()
        XCTAssertThrowsError(try validator.validate(person), "Error for an empty first name should be thrown")

        do {
            _ = try validator.validate(person)
        } catch {
            guard
                let validationError = error as? CreateValidator.CreateValidatorError
            else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }

            XCTAssertEqual(
                validationError,
                CreateValidator.CreateValidatorError.invalidFirstName,
                "Expecting an error where we have an invalid first name"
            )
        }
    }

    func testWithEmptyFirstNameErrorThrown() {

        let person = NewPerson(lastName: "Ads", job: "iOS Dev")
        XCTAssertThrowsError(try validator.validate(person), "Error for an empty first name should be thrown")

        do {
            _ = try validator.validate(person)
        } catch {
            guard
                let validationError = error as? CreateValidator.CreateValidatorError
            else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }

            XCTAssertEqual(
                validationError,
                CreateValidator.CreateValidatorError.invalidFirstName,
                "Expecting an error where we have an invalid first name"
            )
        }
    }

    func testWithEmptyLastNameErrorThrown() {

        let person = NewPerson(firstName: "Tunds", job: "iOS Dev")
        XCTAssertThrowsError(try validator.validate(person), "Error for an empty last name should be thrown")

        do {
            _ = try validator.validate(person)
        } catch {
            guard
                let validationError = error as? CreateValidator.CreateValidatorError
            else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }

            XCTAssertEqual(
                validationError,
                CreateValidator.CreateValidatorError.invalidLastName,
                "Expecting an error where we have an invalid last name"
            )
        }
    }

    func testWithEmptyJobErrorThrown() {

        let person = NewPerson(firstName: "Tunds", lastName: "Ads")
        XCTAssertThrowsError(try validator.validate(person), "Error for an empty job should be thrown")

        do {
            _ = try validator.validate(person)
        } catch {
            guard
                let validationError = error as? CreateValidator.CreateValidatorError
            else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }

            XCTAssertEqual(
                validationError,
                CreateValidator.CreateValidatorError.invalidJob,
                "Expecting an error where we have an invalid job"
            )
        }
    }

    func testWithValidPersonErrorNotThrown() {

        let person = NewPerson(firstName: "Tunds", lastName: "Ads", job: "iOS Dev")

        do {
            _ = try validator.validate(person)
        } catch {
            XCTFail("No errors should be thrown, since the person should be a valid object")
        }
    }
}
