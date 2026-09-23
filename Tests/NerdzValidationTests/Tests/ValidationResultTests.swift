//
//  ValidationResultTests.swift
//  NerdzValidationTests
//
//  Tests for the ValidationResult accessors.
//

import Testing
@testable import NerdzValidation

@Suite("Validation Result Tests")
struct ValidationResultTests {

    @Test func testWhenValidShouldReportValidAndNilMessage() {
        // Arrange
        let result = ValidationResult.valid

        // Act, Assert
        #expect(result.isValid)
        #expect(result.message == nil)
    }

    @Test func testWhenInvalidWithMessageShouldReportInvalidAndMessage() {
        // Arrange
        let expectedMessage = "boom"
        let result = ValidationResult.invalid(message: expectedMessage)

        // Act, Assert
        #expect(result.isValid == false)
        #expect(result.message == expectedMessage)
    }

    @Test func testWhenInvalidWithoutMessageShouldReportInvalidAndNilMessage() {
        let result = ValidationResult.invalid()

        #expect(result.isValid == false)
        #expect(result.message == nil)
    }

    @Test func testWhenComparedShouldSupportEquatable() {
        #expect(ValidationResult.valid == .valid)
        #expect(ValidationResult.invalid(message: "a") == .invalid(message: "a"))
        #expect(ValidationResult.invalid(message: "a") != .invalid(message: "b"))
        #expect(ValidationResult.valid != .invalid(message: nil))
    }
}
