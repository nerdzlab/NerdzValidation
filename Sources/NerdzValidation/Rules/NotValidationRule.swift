//
//  NotValidationRule.swift
//
//
//  Created by Roman Kovalchuk.
//

import Foundation

/// Inverts another rule: passes when the wrapped rule fails, and fails when it passes.
public final class NotValidationRule: ValidationRule {

    /// The wrapped rule whose result is inverted.
    public let rule: ValidationRule
    private let message: String?

    /// Creates the rule.
    /// - Parameters:
    ///   - rule: The rule to invert.
    ///   - message: Optional message returned when the wrapped rule passes (and this rule
    ///     therefore fails).
    public init(_ rule: ValidationRule, message: String? = nil) {
        self.rule = rule
        self.message = message
    }

    public func validate(_ text: String) -> ValidationResult {
        if rule.validate(text).isValid {
            return .invalid(message: message)
        }
        else {
            return .valid
        }
    }
}
