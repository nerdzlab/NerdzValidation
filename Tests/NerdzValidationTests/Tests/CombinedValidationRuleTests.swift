//
//  CombinedValidationRuleTests.swift
//  NerdzValidationTests
//
//  Tests for CombinedValidationRule.
//

import Testing
@testable import NerdzValidation

@Suite("Combined Validation Rule Tests")
struct CombinedValidationRuleTests {

    @Suite("Combining results")
    struct CombiningResultsTests {

        @Test func testWhenAllRulesValidShouldBeValid() {
            // Arrange
            let rule = CombinedValidationRule(
                rules: [TestData.passingRule(), TestData.passingRule()],
                shouldCombineErrorMessages: true
            )

            // Act
            let result = rule.validate("x")

            // Assert
            #expect(result.isValid)
        }

        @Test func testWhenSingleRuleFailsShouldReturnThatMessage() {
            let rule = CombinedValidationRule(
                rules: [TestData.passingRule(), TestData.failingRule("only")],
                shouldCombineErrorMessages: true
            )

            let result = rule.validate("x")

            #expect(result.message == "only")
        }

        @Test func testWhenMultipleRulesFailAndCombiningEnabledShouldMergeMessages() {
            let rule = CombinedValidationRule(
                rules: [TestData.failingRule("one"), TestData.failingRule("two")],
                shouldCombineErrorMessages: true
            )

            let result = rule.validate("x")

            #expect(result.message == "- one\n- two\n")
        }

        @Test func testWhenMultipleRulesFailAndCombiningDisabledShouldReturnFirstMessage() {
            let rule = CombinedValidationRule(
                rules: [TestData.failingRule("one"), TestData.failingRule("two")],
                shouldCombineErrorMessages: false
            )

            let result = rule.validate("x")

            #expect(result.message == "one")
        }
    }

    @Suite("Overriding message")
    struct OverridingMessageTests {

        @Test func testWhenMessageSetAndRuleFailsShouldReturnOverride() {
            let rule = CombinedValidationRule(
                rules: [TestData.failingRule("one"), TestData.failingRule("two")],
                shouldCombineErrorMessages: true,
                message: "override"
            )

            let result = rule.validate("x")

            #expect(result.message == "override")
        }

        @Test func testWhenMessageSetAndAllRulesPassShouldBeValid() {
            let rule = CombinedValidationRule(
                rules: [TestData.passingRule()],
                shouldCombineErrorMessages: true,
                message: "override"
            )

            let result = rule.validate("x")

            #expect(result.isValid)
        }

        @Test func testWhenMessageSetShouldEvaluateEachRuleOnce() {
            // Arrange
            var callCount = 0
            let counting = ByClosureValidationRule(closure: { _ in
                callCount += 1
                return false
            }, message: "fail")
            let rule = CombinedValidationRule(rules: [counting], shouldCombineErrorMessages: true, message: "override")

            // Act
            _ = rule.validate("x")

            // Assert
            #expect(callCount == 1)
        }
    }
}

// MARK: - Test Data

private enum TestData {

    static func passingRule() -> ValidationRule {
        ByClosureValidationRule(closure: { _ in true }, message: "unused")
    }

    static func failingRule(_ message: String) -> ValidationRule {
        ByClosureValidationRule(closure: { _ in false }, message: message)
    }
}
