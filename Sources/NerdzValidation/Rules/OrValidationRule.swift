//
//  OrValidationRule.swift
//
//
//  Created by Roman Kovalchuk.
//

import Foundation

/// Passes when at least one of the wrapped rules passes.
///
/// This is the any-of counterpart to ``CombinedValidationRule`` (which requires every rule to
/// pass). Useful for accepting more than one valid format, for example an email or a phone.
public final class OrValidationRule: ValidationRule {

    /// The rules evaluated in order; the first passing rule makes the whole rule pass.
    public let rules: [ValidationRule]
    private let message: String?

    /// Creates the rule.
    /// - Parameters:
    ///   - rules: The rules to evaluate. The result is valid when any of them passes.
    ///   - message: Optional message returned when every rule fails. When `nil`, the first
    ///     failing rule's message is used.
    public init(rules: [ValidationRule], message: String? = nil) {
        self.rules = rules
        self.message = message
    }

    public func validate(_ text: String) -> ValidationResult {
        let results = rules.map { $0.validate(text) }

        if results.contains(where: { $0.isValid }) {
            return .valid
        }

        if let message = message {
            return .invalid(message: message)
        }

        return .invalid(message: results.compactMap { $0.message }.first)
    }
}
