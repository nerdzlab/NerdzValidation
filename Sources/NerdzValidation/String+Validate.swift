//
//  String+Validate.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

extension String: NZValidationExtensionCompatible { }

/// The `String` validation entry points, reached through `"...".nzv`.
public extension NZValidationExtensionData where Base == String {
    /// Validates the string against several rules at once.
    /// - Parameters:
    ///   - rules: The rules to evaluate.
    ///   - message: Optional message replacing individual messages when any rule fails.
    ///   - shouldCombineErrorMessages: When `true`, failing messages are merged into one string.
    /// - Returns: The combined ``ValidationResult``.
    func validate(with rules: ValidationRule..., message: String? = nil, shouldCombineErrorMessages: Bool = true) -> ValidationResult {
        CombinedValidationRule(rules: rules, shouldCombineErrorMessages: shouldCombineErrorMessages, message: message).validate(base)
    }

    /// Starts a chain of rules by returning a ``RulesContainer`` for this string.
    func combine() -> RulesContainer {
        RulesContainer(text: base)
    }

    /// Validates that the string is not empty.
    /// - Parameter message: Optional message overriding the default.
    func notEmpty(message: String? = nil) -> ValidationResult {
        NotEmptyValidationRule(message: message).validate(base)
    }

    /// Validates that the string looks like an email address.
    /// - Parameter message: Optional message overriding the default.
    func isEmail(message: String? = nil) -> ValidationResult {
        IsEmailValidationRule(message: message).validate(base)
    }

    /// Validates that the string looks like a phone number.
    /// - Parameter message: Optional message overriding the default.
    func isPhone(message: String? = nil) -> ValidationResult {
        IsPhoneValidationRule(message: message).validate(base)
    }

    /// Validates the string with a custom closure.
    /// - Parameters:
    ///   - closure: The predicate to evaluate; return `true` to pass.
    ///   - message: Message used when the closure returns `false`.
    func validByClosure(_ closure: @escaping ByClosureValidationRule.Closure, message: String?) -> ValidationResult {
        ByClosureValidationRule(closure: closure, message: message).validate(base)
    }

    /// Validates that the string matches a regular expression.
    /// - Parameters:
    ///   - regex: The regular expression pattern.
    ///   - message: Optional message overriding the default.
    func matchRegex(_ regex: String, message: String? = nil) -> ValidationResult {
        RegexValidationRule(pattern: regex, message: message).validate(base)
    }

    /// Validates that the string is shorter than `value` UTF-16 units.
    /// - Parameters:
    ///   - value: The exclusive upper bound.
    ///   - message: Optional message overriding the default.
    func lengthLessThan(_ value: Int, message: String? = nil) -> ValidationResult {
        LengthRangeValidationRule(upperBound: value, upperBoundMessage: message).validate(base)
    }

    /// Validates that the string is longer than `value` UTF-16 units.
    /// - Parameters:
    ///   - value: The exclusive lower bound.
    ///   - message: Optional message overriding the default.
    func lengthHigherThan(_ value: Int, message: String? = nil) -> ValidationResult {
        LengthRangeValidationRule(lowerBound: value, lowerBoundMessage: message).validate(base)
    }

    /// Validates that the string length falls within a range.
    /// - Parameters:
    ///   - range: The allowed length range in UTF-16 units.
    ///   - lowerBoundMessage: Optional message used when the string is too short.
    ///   - upperBoundMessage: Optional message used when the string is too long.
    func lengthInRange(
        _ range: Range<Int>,
        lowerBoundMessage: String? = nil,
        upperBoundMessage: String? = nil
    ) -> ValidationResult
    {
        let rule = LengthRangeValidationRule(
            lowerBound: range.lowerBound,
            upperBound: range.upperBound,
            lowerBoundMessage: lowerBoundMessage,
            upperBoundMessage: upperBoundMessage
        )
        
        return rule.validate(base)
    }
}
