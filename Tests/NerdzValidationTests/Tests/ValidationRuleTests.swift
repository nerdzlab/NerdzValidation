//
//  ValidationRuleTests.swift
//  NerdzValidationTests
//
//  Tests for the individual ValidationRule implementations.
//

import Testing
@testable import NerdzValidation

@Suite("Validation Rule Tests")
struct ValidationRuleTests {

    @Suite("Not Empty Rule")
    struct NotEmptyRuleTests {

        @Test func testWhenEmptyShouldBeInvalid() {
            // Arrange
            let rule = NotEmptyValidationRule()

            // Act
            let result = rule.validate("")

            // Assert
            #expect(result.isValid == false)
        }

        @Test(arguments: TestData.nonEmptyStrings)
        func testWhenNonEmptyShouldBeValid(_ text: String) {
            let rule = NotEmptyValidationRule()

            let result = rule.validate(text)

            #expect(result.isValid)
        }

        @Test func testWhenEmptyWithCustomMessageShouldReturnCustomMessage() {
            let rule = NotEmptyValidationRule(message: "Required")

            let result = rule.validate("")

            #expect(result.message == "Required")
        }

        @Test func testWhenEmptyWithNoMessageShouldReturnDefaultMessage() {
            let rule = NotEmptyValidationRule()

            let result = rule.validate("")

            #expect(result.message == "String should not be empty")
        }
    }

    @Suite("Email Rule")
    struct EmailRuleTests {

        @Test(arguments: TestData.validEmails)
        func testWhenValidEmailShouldBeValid(_ email: String) {
            let rule = IsEmailValidationRule()

            let result = rule.validate(email)

            #expect(result.isValid)
        }

        @Test(arguments: TestData.invalidEmails)
        func testWhenInvalidEmailShouldBeInvalid(_ email: String) {
            let rule = IsEmailValidationRule()

            let result = rule.validate(email)

            #expect(result.isValid == false)
        }

        @Test func testWhenInvalidWithNoMessageShouldReturnDefaultMessage() {
            let rule = IsEmailValidationRule()

            let result = rule.validate("nope")

            #expect(result.message == "Invalid email address")
        }

        @Test func testWhenInvalidWithCustomMessageShouldReturnCustomMessage() {
            let rule = IsEmailValidationRule(message: "Bad email")

            let result = rule.validate("nope")

            #expect(result.message == "Bad email")
        }

        @Test func testWhenEmailEmbeddedInOtherTextShouldBeInvalid() {
            // The pattern must match the whole string, not a substring of it.
            let rule = IsEmailValidationRule()

            let result = rule.validate("hello a@b.io there")

            #expect(result.isValid == false)
        }
    }

    @Suite("Phone Rule")
    struct PhoneRuleTests {

        @Test(arguments: TestData.validPhones)
        func testWhenValidPhoneShouldBeValid(_ phone: String) {
            let rule = IsPhoneValidationRule()

            let result = rule.validate(phone)

            #expect(result.isValid)
        }

        @Test(arguments: TestData.invalidPhones)
        func testWhenInvalidPhoneShouldBeInvalid(_ phone: String) {
            let rule = IsPhoneValidationRule()

            let result = rule.validate(phone)

            #expect(result.isValid == false)
        }

        @Test func testWhenInvalidWithNoMessageShouldReturnDefaultMessage() {
            let rule = IsPhoneValidationRule()

            let result = rule.validate("abc")

            #expect(result.message == "Invalid phone number")
        }

        @Test func testWhenInvalidWithCustomMessageShouldReturnCustomMessage() {
            let rule = IsPhoneValidationRule(message: "Bad phone")

            let result = rule.validate("abc")

            #expect(result.message == "Bad phone")
        }
    }

    @Suite("Regex Rule")
    struct RegexRuleTests {

        @Test func testWhenPatternMatchesFullyShouldBeValid() {
            let rule = RegexValidationRule(pattern: "^[0-9]{3}$")

            let result = rule.validate("123")

            #expect(result.isValid)
        }

        @Test func testWhenPatternDoesNotMatchShouldBeInvalid() {
            let rule = RegexValidationRule(pattern: "^[0-9]{3}$")

            let result = rule.validate("abc")

            #expect(result.isValid == false)
        }

        @Test func testWhenTrailingTextDoesNotMatchShouldBeInvalid() {
            // Pattern matches "12" but not the trailing "a"; the whole string must match.
            let rule = RegexValidationRule(pattern: "[0-9]+")

            let result = rule.validate("12a")

            #expect(result.isValid == false)
        }

        @Test func testWhenPatternIsInvalidShouldBeInvalid() {
            // An unbalanced group is an invalid NSRegularExpression pattern.
            let rule = RegexValidationRule(pattern: "([")

            let result = rule.validate("anything")

            #expect(result.isValid == false)
        }

        @Test func testWhenInvalidShouldIncludePatternInMessage() {
            let rule = RegexValidationRule(pattern: "^x$")

            let result = rule.validate("y")

            #expect(result.message?.contains("^x$") == true)
        }
    }

    @Suite("Length Range Rule")
    struct LengthRangeRuleTests {

        @Test func testWhenBelowLowerBoundShouldBeInvalid() {
            let rule = LengthRangeValidationRule(lowerBound: 3)

            let result = rule.validate("ab")

            #expect(result.isValid == false)
        }

        @Test func testWhenAboveUpperBoundShouldBeInvalid() {
            let rule = LengthRangeValidationRule(upperBound: 3)

            let result = rule.validate("abcd")

            #expect(result.isValid == false)
        }

        @Test func testWhenWithinBoundsShouldBeValid() {
            let rule = LengthRangeValidationRule(lowerBound: 2, upperBound: 4)

            let result = rule.validate("abc")

            #expect(result.isValid)
        }

        @Test func testWhenAtBoundariesShouldBeValid() {
            let rule = LengthRangeValidationRule(lowerBound: 2, upperBound: 4)

            #expect(rule.validate("ab").isValid)
            #expect(rule.validate("abcd").isValid)
        }

        @Test func testWhenMultiUnitCharacterShouldCountUTF16() {
            // A family emoji is several UTF-16 code units, so it exceeds a tiny upper bound.
            let rule = LengthRangeValidationRule(upperBound: 1)

            let result = rule.validate("👨‍👩‍👧")

            #expect(result.isValid == false)
        }

        @Test func testWhenOutOfBoundsWithCustomMessagesShouldReturnThem() {
            let rule = LengthRangeValidationRule(
                lowerBound: 2,
                upperBound: 4,
                lowerBoundMessage: "too short",
                upperBoundMessage: "too long"
            )

            #expect(rule.validate("a").message == "too short")
            #expect(rule.validate("abcde").message == "too long")
        }
    }

    @Suite("By Closure Rule")
    struct ByClosureRuleTests {

        @Test func testWhenClosureReturnsTrueShouldBeValid() {
            let rule = ByClosureValidationRule(closure: { _ in true })

            let result = rule.validate("x")

            #expect(result.isValid)
        }

        @Test func testWhenClosureReturnsFalseShouldBeInvalidWithMessage() {
            let rule = ByClosureValidationRule(closure: { _ in false }, message: "nope")

            let result = rule.validate("x")

            #expect(result.isValid == false)
            #expect(result.message == "nope")
        }

        @Test func testWhenNoMessageShouldReturnDefaultMessage() {
            let rule = ByClosureValidationRule(closure: { _ in false })

            let result = rule.validate("x")

            #expect(result.message == "String is invalid")
        }

        @Test func testWhenValidatingShouldPassTextToClosure() {
            var captured = ""
            let rule = ByClosureValidationRule(closure: { captured = $0; return true })

            _ = rule.validate("payload")

            #expect(captured == "payload")
        }
    }
}

// MARK: - Test Data

private enum TestData {

    static let nonEmptyStrings = ["a", " ", "hello", "123"]

    static let validEmails = [
        "someEmail@gmail.com",
        "first.last@sub.domain.co",
        "user+tag@example.org",
        "a@b.io"
    ]

    static let invalidEmails = [
        "",
        "plainaddress",
        "@missinglocal.org",
        "missingat.com"
    ]

    // NOTE: the leading optional uses a possessive quantifier ([0-9+]{0,1}+), so a bare
    // 5-digit string like "12345" fails (the first char is consumed without backtracking,
    // effectively requiring 6+ characters).
    static let validPhones = [
        "123456",
        "+380 (99) 123 45 67",
        "0501234567",
        "+1 (555) 000 0000"
    ]

    static let invalidPhones = [
        "",
        "abc",
        "12"
    ]
}
