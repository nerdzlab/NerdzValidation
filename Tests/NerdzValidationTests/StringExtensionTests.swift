//
//  StringExtensionTests.swift
//  NerdzValidationTests
//
//  Tests for the `.nzv` String entry points and single-rule shortcuts.
//

import Testing
@testable import NerdzValidation

@Suite("String .nzv extension")
struct StringNZVExtensionTests {

    @Test("notEmpty shortcut")
    func notEmpty() {
        #expect("x".nzv.notEmpty().isValid)
        #expect("".nzv.notEmpty().isValid == false)
    }

    @Test("isEmail shortcut")
    func isEmail() {
        #expect("a@b.io".nzv.isEmail().isValid)
        #expect("nope".nzv.isEmail().isValid == false)
    }

    @Test("isPhone shortcut")
    func isPhone() {
        #expect("+380 (99) 123 45 67".nzv.isPhone().isValid)
        #expect("abc".nzv.isPhone().isValid == false)
    }

    @Test("matchRegex shortcut")
    func matchRegex() {
        #expect("123".nzv.matchRegex("^[0-9]+$").isValid)
        #expect("abc".nzv.matchRegex("^[0-9]+$").isValid == false)
    }

    @Test("validByClosure shortcut")
    func validByClosure() {
        #expect("abc".nzv.validByClosure({ $0.count == 3 }, message: "len").isValid)
        #expect("ab".nzv.validByClosure({ $0.count == 3 }, message: "len").isValid == false)
    }

    @Test("lengthLessThan shortcut")
    func lengthLessThan() {
        #expect("ab".nzv.lengthLessThan(3).isValid)
        #expect("abcd".nzv.lengthLessThan(3).isValid == false)
    }

    @Test("lengthHigherThan shortcut")
    func lengthHigherThan() {
        #expect("abcd".nzv.lengthHigherThan(3).isValid)
        #expect("ab".nzv.lengthHigherThan(3).isValid == false)
    }

    @Test("lengthInRange shortcut")
    func lengthInRange() {
        #expect("abc".nzv.lengthInRange(2..<5).isValid)
        #expect("a".nzv.lengthInRange(2..<5).isValid == false)
    }

    @Test("validate(with:) variadic rules combine")
    func variadicValidate() {
        let result = "".nzv.validate(
            with: NotEmptyValidationRule(message: "empty"),
            IsEmailValidationRule(message: "email")
        )
        #expect(result.isValid == false)
        #expect(result.message == "- empty\n- email\n")
    }

    @Test("combine() returns a fresh independent container")
    func combineFresh() {
        let base = "x".nzv
        let first = base.combine().notEmpty()
        let second = base.combine()
        // Adding to `first` must not affect `second`.
        _ = first.isEmail()
        #expect(second.validate().isValid)
    }
}
