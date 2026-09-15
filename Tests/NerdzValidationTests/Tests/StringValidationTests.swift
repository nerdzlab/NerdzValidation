//
//  StringValidationTests.swift
//  NerdzValidationTests
//
//  Tests for the `.nzv` String entry points and single-rule shortcuts.
//

import Testing
@testable import NerdzValidation

@Suite("String Validation Tests")
struct StringValidationTests {

    @Suite("Single-rule shortcuts")
    struct SingleRuleShortcutTests {

        @Test func testWhenNotEmptyShortcutShouldValidateEmptiness() {
            #expect("x".nzv.notEmpty().isValid)
            #expect("".nzv.notEmpty().isValid == false)
        }

        @Test func testWhenIsEmailShortcutShouldValidateEmail() {
            #expect("a@b.io".nzv.isEmail().isValid)
            #expect("nope".nzv.isEmail().isValid == false)
        }

        @Test func testWhenIsPhoneShortcutShouldValidatePhone() {
            #expect("+380 (99) 123 45 67".nzv.isPhone().isValid)
            #expect("abc".nzv.isPhone().isValid == false)
        }

        @Test func testWhenMatchRegexShortcutShouldValidatePattern() {
            #expect("123".nzv.matchRegex("^[0-9]+$").isValid)
            #expect("abc".nzv.matchRegex("^[0-9]+$").isValid == false)
        }

        @Test func testWhenValidByClosureShortcutShouldEvaluateClosure() {
            #expect("abc".nzv.validByClosure({ $0.count == 3 }, message: "len").isValid)
            #expect("ab".nzv.validByClosure({ $0.count == 3 }, message: "len").isValid == false)
        }

        @Test func testWhenLengthLessThanShortcutShouldValidateUpperBound() {
            #expect("ab".nzv.lengthLessThan(3).isValid)
            #expect("abcd".nzv.lengthLessThan(3).isValid == false)
        }

        @Test func testWhenLengthHigherThanShortcutShouldValidateLowerBound() {
            #expect("abcd".nzv.lengthHigherThan(3).isValid)
            #expect("ab".nzv.lengthHigherThan(3).isValid == false)
        }

        @Test func testWhenLengthInRangeShortcutShouldValidateRange() {
            #expect("abc".nzv.lengthInRange(2..<5).isValid)
            #expect("a".nzv.lengthInRange(2..<5).isValid == false)
        }
    }

    @Suite("Variadic validate")
    struct VariadicValidateTests {

        @Test func testWhenMultipleRulesFailShouldMergeMessages() {
            // Arrange
            let notEmptyMessage = "empty"
            let emailMessage = "email"

            // Act
            let result = "".nzv.validate(
                with: NotEmptyValidationRule(message: notEmptyMessage),
                IsEmailValidationRule(message: emailMessage)
            )

            // Assert
            #expect(result.isValid == false)
            #expect(result.message == "- \(notEmptyMessage)\n- \(emailMessage)\n")
        }
    }

    @Suite("Combine")
    struct CombineTests {

        @Test func testWhenCombineCalledTwiceShouldReturnIndependentContainers() {
            // Arrange
            let base = "x".nzv
            let first = base.combine().notEmpty()
            let second = base.combine()

            // Act: mutating `first` must not affect `second`.
            _ = first.isEmail()

            // Assert
            #expect(second.validate().isValid)
        }
    }
}
