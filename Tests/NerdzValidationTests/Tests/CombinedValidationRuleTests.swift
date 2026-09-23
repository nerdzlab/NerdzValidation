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
            let message = "only"
            let rule = CombinedValidationRule(
                rules: [TestData.passingRule(), TestData.failingRule(message)],
                shouldCombineErrorMessages: true
            )

            let result = rule.validate("x")

            #expect(result.message == message)
        }

        @Test func testWhenMultipleRulesFailAndCombiningEnabledShouldMergeMessages() {
            let firstMessage = "one"
            let secondMessage = "two"
            let rule = CombinedValidationRule(
                rules: [TestData.failingRule(firstMessage), TestData.failingRule(secondMessage)],
                shouldCombineErrorMessages: true
            )

            let result = rule.validate("x")

            #expect(result.message == "- \(firstMessage)\n- \(secondMessage)\n")
        }

        @Test func testWhenMultipleRulesFailAndCombiningDisabledShouldReturnFirstMessage() {
            let firstMessage = "one"
            let secondMessage = "two"
            let rule = CombinedValidationRule(
                rules: [TestData.failingRule(firstMessage), TestData.failingRule(secondMessage)],
                shouldCombineErrorMessages: false
            )

            let result = rule.validate("x")

            #expect(result.message == firstMessage)
        }
    }

    @Suite("Overriding message")
    struct OverridingMessageTests {

        @Test func testWhenMessageSetAndRuleFailsShouldReturnOverride() {
            let overrideMessage = "override"
            let rule = CombinedValidationRule(
                rules: [TestData.failingRule("one"), TestData.failingRule("two")],
                shouldCombineErrorMessages: true,
                message: overrideMessage
            )

            let result = rule.validate("x")

            #expect(result.message == overrideMessage)
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
            let counter = CallCounter()
            let counting = ByClosureValidationRule(closure: { _ in
                counter.increment()
                return false
            }, message: "fail")
            let rule = CombinedValidationRule(rules: [counting], shouldCombineErrorMessages: true, message: "override")

            // Act
            _ = rule.validate("x")

            // Assert
            #expect(counter.count == 1)
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
