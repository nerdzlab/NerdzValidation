//
//  RulesContainerTests.swift
//  NerdzValidationTests
//
//  Tests for the RulesContainer chaining builder.
//

import Testing
@testable import NerdzValidation

@Suite("Rules Container Tests")
struct RulesContainerTests {

    @Suite("Chaining")
    struct ChainingTests {

        @Test func testWhenAllChainedRulesPassShouldBeValid() {
            // Arrange, Act
            let result = "someEmail@gmail.com".nzv
                .combine()
                .notEmpty()
                .isEmail()
                .lengthInRange(4..<200)
                .validate()

            // Assert
            #expect(result.isValid)
        }

        @Test func testWhenAChainedRuleFailsShouldBeInvalid() {
            let result = "".nzv
                .combine()
                .notEmpty()
                .isEmail()
                .validate()

            #expect(result.isValid == false)
        }

        @Test func testWhenAllConvenienceMethodsChainShouldBeValid() {
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

        @Test func testWhenConvenienceEmailRuleFailsShouldBeInvalid() {
            let result = "nope".nzv.combine().isEmail().validate()

            #expect(result.isValid == false)
        }

        @Test func testWhenConvenienceURLRuleChainedShouldValidateURL() {
            #expect("https://example.com".nzv.combine().notEmpty().isURL().validate().isValid)
            #expect("notaurl".nzv.combine().notEmpty().isURL().validate().isValid == false)
        }
    }

    @Suite("Custom rules and messages")
    struct CustomRuleTests {

        @Test func testWhenContainerMessageSetShouldOverrideCombinedOutput() {
            let overrideMessage = "Please enter a valid email"

            let result = "".nzv
                .combine()
                .notEmpty()
                .isEmail()
                .validate(with: overrideMessage)

            #expect(result.message == overrideMessage)
        }

        @Test func testWhenCustomRuleAppendedShouldBeApplied() {
            // Arrange
            let customMessage = "custom fail"
            let alwaysFail = ByClosureValidationRule(closure: { _ in false }, message: customMessage)

            // Act
            let result = "x".nzv.combine().validate(with: alwaysFail).validate()

            // Assert
            #expect(result.message == customMessage)
        }
    }
}
