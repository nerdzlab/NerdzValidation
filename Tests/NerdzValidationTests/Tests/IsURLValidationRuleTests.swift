//
//  IsURLValidationRuleTests.swift
//  NerdzValidationTests
//
//  Tests for the IsURLValidationRule.
//

import Testing
@testable import NerdzValidation

@Suite("Is URL Validation Rule Tests")
struct IsURLValidationRuleTests {

    @Suite("Valid input")
    struct ValidInputTests {

        @Test(arguments: TestData.validURLs)
        func testWhenValidURLShouldBeValid(_ url: String) {
            let rule = IsURLValidationRule()

            let result = rule.validate(url)

            #expect(result.isValid)
        }
    }

    @Suite("Invalid input")
    struct InvalidInputTests {

        @Test(arguments: TestData.invalidURLs)
        func testWhenInvalidURLShouldBeInvalid(_ url: String) {
            let rule = IsURLValidationRule()

            let result = rule.validate(url)

            #expect(result.isValid == false)
        }

        @Test func testWhenInvalidWithNoMessageShouldReturnDefaultMessage() {
            let rule = IsURLValidationRule()

            let result = rule.validate("notaurl")

            #expect(result.message == "Invalid URL")
        }

        @Test func testWhenInvalidWithCustomMessageShouldReturnCustomMessage() {
            let customMessage = "Bad URL"
            let rule = IsURLValidationRule(message: customMessage)

            let result = rule.validate("notaurl")

            #expect(result.message == customMessage)
        }
    }
}

// MARK: - Test Data

private enum TestData {

    static let validURLs = [
        "https://example.com",
        "http://localhost",
        "example.com",
        "ftp://foo.bar"
    ]

    static let invalidURLs = [
        "",
        "notaurl",
        "has space.com"
    ]
}
