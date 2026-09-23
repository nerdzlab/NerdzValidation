//
//  CombinatorRuleTests.swift
//  NerdzValidationTests
//
//  Tests for the Or / Not combinator rules.
//

import Testing
@testable import NerdzValidation

@Suite("Combinator Rule Tests")
struct CombinatorRuleTests {

    @Suite("Or Rule")
    struct OrRuleTests {

        @Test func testWhenOneRulePassesShouldBeValid() {
            let rule = OrValidationRule(rules: [TestData.failingRule("a"), TestData.passingRule()])

            let result = rule.validate("x")

            #expect(result.isValid)
        }

        @Test func testWhenAllRulesPassShouldBeValid() {
            let rule = OrValidationRule(rules: [TestData.passingRule(), TestData.passingRule()])

            let result = rule.validate("x")

            #expect(result.isValid)
        }

        @Test func testWhenAllRulesFailShouldReturnFirstMessage() {
            let firstMessage = "first"
            let secondMessage = "second"
            let rule = OrValidationRule(rules: [TestData.failingRule(firstMessage), TestData.failingRule(secondMessage)])

            let result = rule.validate("x")

            #expect(result.isValid == false)
            #expect(result.message == firstMessage)
        }

        @Test func testWhenAllRulesFailWithOverrideShouldReturnOverride() {
            let overrideMessage = "none matched"
            let rule = OrValidationRule(
                rules: [TestData.failingRule("first"), TestData.failingRule("second")],
                message: overrideMessage
            )

            let result = rule.validate("x")

            #expect(result.message == overrideMessage)
        }
    }

    @Suite("Not Rule")
    struct NotRuleTests {

        @Test func testWhenWrappedRuleFailsShouldBeValid() {
            let rule = NotValidationRule(TestData.failingRule("inner"))

            let result = rule.validate("x")

            #expect(result.isValid)
        }

        @Test func testWhenWrappedRulePassesShouldBeInvalid() {
            let message = "should not match"
            let rule = NotValidationRule(TestData.passingRule(), message: message)

            let result = rule.validate("x")

            #expect(result.isValid == false)
            #expect(result.message == message)
        }
    }

    @Suite("Container conveniences")
    struct ContainerConvenienceTests {

        @Test func testWhenAnyOfChainedShouldPassIfOneMatches() {
            let result = "a@b.io".nzv
                .combine()
                .any(of: [IsEmailValidationRule(), IsPhoneValidationRule()])
                .validate()

            #expect(result.isValid)
        }

        @Test func testWhenNotChainedShouldInvertRule() {
            let message = "must be empty"

            let result = "not empty".nzv
                .combine()
                .not(NotEmptyValidationRule(), message: message)
                .validate()

            #expect(result.message == message)
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
