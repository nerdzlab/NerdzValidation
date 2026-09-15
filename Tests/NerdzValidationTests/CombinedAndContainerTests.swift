//
//  CombinedAndContainerTests.swift
//  NerdzValidationTests
//
//  Tests for CombinedValidationRule, RulesContainer and ValidationResult.
//

import Testing
@testable import NerdzValidation

@Suite("CombinedValidationRule")
struct CombinedValidationRuleTests {

    private func failing(_ message: String) -> ValidationRule {
        ByClosureValidationRule(closure: { _ in false }, message: message)
    }

    private func passing() -> ValidationRule {
        ByClosureValidationRule(closure: { _ in true }, message: "unused")
    }

    @Test("All rules valid results in valid")
    func allValid() {
        let rule = CombinedValidationRule(rules: [passing(), passing()], shouldCombineErrorMessages: true)
        #expect(rule.validate("x").isValid)
    }

    @Test("Single failure returns that rule's message")
    func singleFailure() {
        let rule = CombinedValidationRule(rules: [passing(), failing("only")], shouldCombineErrorMessages: true)
        #expect(rule.validate("x").message == "only")
    }

    @Test("Multiple failures are combined when enabled")
    func combinedMessages() {
        let rule = CombinedValidationRule(rules: [failing("one"), failing("two")], shouldCombineErrorMessages: true)
        #expect(rule.validate("x").message == "- one\n- two\n")
    }

    @Test("Multiple failures return first message when combining disabled")
    func notCombinedMessages() {
        let rule = CombinedValidationRule(rules: [failing("one"), failing("two")], shouldCombineErrorMessages: false)
        #expect(rule.validate("x").message == "one")
    }

    @Test("Container-level message overrides individual messages on failure")
    func messageOverride() {
        let rule = CombinedValidationRule(
            rules: [failing("one"), failing("two")],
            shouldCombineErrorMessages: true,
            message: "override"
        )
        #expect(rule.validate("x").message == "override")
    }

    @Test("Container-level message is ignored when all rules pass")
    func messageIgnoredWhenValid() {
        let rule = CombinedValidationRule(
            rules: [passing()],
            shouldCombineErrorMessages: true,
            message: "override"
        )
        #expect(rule.validate("x").isValid)
    }
}

@Suite("RulesContainer")
struct RulesContainerTests {

    @Test("Chained rules all pass")
    func chainValid() {
        let result = "someEmail@gmail.com".nzv
            .combine()
            .notEmpty()
            .isEmail()
            .lengthInRange(4..<200)
            .validate()
        #expect(result.isValid)
    }

    @Test("Chained rules surface a failure")
    func chainInvalid() {
        let result = "".nzv
            .combine()
            .notEmpty()
            .isEmail()
            .validate()
        #expect(result.isValid == false)
    }

    @Test("Container-level message overrides combined output")
    func containerMessage() {
        let result = "".nzv
            .combine()
            .notEmpty()
            .isEmail()
            .validate(with: "Please enter a valid email")
        #expect(result.message == "Please enter a valid email")
    }

    @Test("validate(with: rule) appends a custom rule")
    func customRuleAppended() {
        let alwaysFail = ByClosureValidationRule(closure: { _ in false }, message: "custom fail")
        let result = "x".nzv.combine().validate(with: alwaysFail).validate()
        #expect(result.message == "custom fail")
    }

    @Test("All container convenience methods chain and pass")
    func allConvenienceMethodsValid() {
        let result = "+380 (99) 123 45 67".nzv
            .combine()
            .notEmpty()
            .isPhone()
            .validByClosure({ !$0.isEmpty }, message: "closure")
            .matchRegex("^.+$")
            .lengthHigherThan(3)
            .lengthLessThan(50)
            .lengthInRange(4..<50)
            .validate()
        #expect(result.isValid)
    }

    @Test("Container isEmail convenience method fails invalid input")
    func containerIsEmailInvalid() {
        let result = "nope".nzv.combine().isEmail().validate()
        #expect(result.isValid == false)
    }
}

@Suite("ValidationResult")
struct ValidationResultTests {

    @Test("Valid case reports isValid true and nil message")
    func validCase() {
        let result = ValidationResult.valid
        #expect(result.isValid)
        #expect(result.message == nil)
    }

    @Test("Invalid case reports isValid false and its message")
    func invalidCase() {
        let result = ValidationResult.invalid(message: "boom")
        #expect(result.isValid == false)
        #expect(result.message == "boom")
    }

    @Test("Invalid case with no message")
    func invalidNoMessage() {
        let result = ValidationResult.invalid()
        #expect(result.isValid == false)
        #expect(result.message == nil)
    }
}
