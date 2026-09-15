//
//  RuleTests.swift
//  NerdzValidationTests
//
//  Tests for the individual ValidationRule implementations.
//

import Testing
@testable import NerdzValidation

@Suite("NotEmptyValidationRule")
struct NotEmptyValidationRuleTests {

    @Test("Empty string is invalid")
    func emptyIsInvalid() {
        #expect(NotEmptyValidationRule().validate("").isValid == false)
    }

    @Test("Non-empty string is valid", arguments: ["a", " ", "hello", "123"])
    func nonEmptyIsValid(_ text: String) {
        #expect(NotEmptyValidationRule().validate(text).isValid)
    }

    @Test("Custom message is propagated on failure")
    func customMessage() {
        let result = NotEmptyValidationRule(message: "Required").validate("")
        #expect(result.message == "Required")
    }

    @Test("Default message is used when none provided")
    func defaultMessage() {
        let result = NotEmptyValidationRule().validate("")
        #expect(result.message == "String should not be empty")
    }
}

@Suite("IsEmailValidationRule")
struct IsEmailValidationRuleTests {

    @Test("Valid email addresses pass", arguments: [
        "someEmail@gmail.com",
        "first.last@sub.domain.co",
        "user+tag@example.org",
        "a@b.io"
    ])
    func validEmails(_ email: String) {
        #expect(IsEmailValidationRule().validate(email).isValid)
    }

    @Test("Invalid email addresses fail", arguments: [
        "",
        "plainaddress",
        "@missinglocal.org",
        "missingat.com"
    ])
    func invalidEmails(_ email: String) {
        #expect(IsEmailValidationRule().validate(email).isValid == false)
    }

    @Test("Default message on failure")
    func defaultMessage() {
        #expect(IsEmailValidationRule().validate("nope").message == "Invalid email address")
    }

    @Test("Custom message on failure")
    func customMessage() {
        #expect(IsEmailValidationRule(message: "Bad email").validate("nope").message == "Bad email")
    }
}

@Suite("IsPhoneValidationRule")
struct IsPhoneValidationRuleTests {

    // NOTE: the leading optional uses a possessive quantifier ([0-9+]{0,1}+), so a bare
    // 5-digit string like "12345" fails (the first char is consumed without backtracking,
    // effectively requiring 6+ characters). Documented here; see fix/regex-anchoring.
    @Test("Valid phone numbers pass", arguments: [
        "123456",
        "+380 (99) 123 45 67",
        "0501234567",
        "+1 (555) 000 0000"
    ])
    func validPhones(_ phone: String) {
        #expect(IsPhoneValidationRule().validate(phone).isValid)
    }

    @Test("Invalid phone numbers fail", arguments: [
        "",
        "abc",
        "12"
    ])
    func invalidPhones(_ phone: String) {
        #expect(IsPhoneValidationRule().validate(phone).isValid == false)
    }

    @Test("Default message on failure")
    func defaultMessage() {
        #expect(IsPhoneValidationRule().validate("abc").message == "Invalid phone number")
    }

    @Test("Custom message on failure")
    func customMessage() {
        #expect(IsPhoneValidationRule(message: "Bad phone").validate("abc").message == "Bad phone")
    }
}

@Suite("RegexValidationRule")
struct RegexValidationRuleTests {

    @Test("Matching text is valid")
    func matches() {
        #expect(RegexValidationRule(pattern: "^[0-9]{3}$").validate("123").isValid)
    }

    @Test("Non-matching text is invalid")
    func doesNotMatch() {
        #expect(RegexValidationRule(pattern: "^[0-9]{3}$").validate("abc").isValid == false)
    }

    @Test("Invalid pattern returns invalid instead of crashing")
    func invalidPattern() {
        // Unbalanced group is an invalid NSRegularExpression pattern.
        #expect(RegexValidationRule(pattern: "([").validate("anything").isValid == false)
    }

    @Test("Default message includes the pattern")
    func defaultMessage() {
        let rule = RegexValidationRule(pattern: "^x$")
        #expect(rule.validate("y").message?.contains("^x$") == true)
    }
}

@Suite("LengthRangeValidationRule")
struct LengthRangeValidationRuleTests {

    @Test("Below lower bound is invalid")
    func belowLower() {
        #expect(LengthRangeValidationRule(lowerBound: 3).validate("ab").isValid == false)
    }

    @Test("Above upper bound is invalid")
    func aboveUpper() {
        #expect(LengthRangeValidationRule(upperBound: 3).validate("abcd").isValid == false)
    }

    @Test("Within bounds is valid")
    func withinBounds() {
        #expect(LengthRangeValidationRule(lowerBound: 2, upperBound: 4).validate("abc").isValid)
    }

    @Test("Boundary values are inclusive")
    func boundariesInclusive() {
        let rule = LengthRangeValidationRule(lowerBound: 2, upperBound: 4)
        #expect(rule.validate("ab").isValid)
        #expect(rule.validate("abcd").isValid)
    }

    @Test("Length is counted in UTF-16 units")
    func utf16Counting() {
        // A family emoji is multiple UTF-16 code units, so it exceeds a tiny upper bound.
        #expect(LengthRangeValidationRule(upperBound: 1).validate("👨‍👩‍👧").isValid == false)
    }

    @Test("Custom bound messages are used")
    func customMessages() {
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

@Suite("ByClosureValidationRule")
struct ByClosureValidationRuleTests {

    @Test("Closure returning true is valid")
    func trueIsValid() {
        #expect(ByClosureValidationRule(closure: { _ in true }).validate("x").isValid)
    }

    @Test("Closure returning false is invalid with message")
    func falseIsInvalid() {
        let result = ByClosureValidationRule(closure: { _ in false }, message: "nope").validate("x")
        #expect(result.isValid == false)
        #expect(result.message == "nope")
    }

    @Test("Default message when none provided")
    func defaultMessage() {
        #expect(ByClosureValidationRule(closure: { _ in false }).validate("x").message == "String is invalid")
    }

    @Test("Closure receives the validated text")
    func receivesText() {
        var captured = ""
        _ = ByClosureValidationRule(closure: { captured = $0; return true }).validate("payload")
        #expect(captured == "payload")
    }
}
