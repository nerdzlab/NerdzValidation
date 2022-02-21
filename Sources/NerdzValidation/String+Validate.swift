//
//  String+Validate.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

/// Extension for implementing NerdzValidation methods
extension String: NZValidationExtensionCompatible { }

public extension NZValidationExtensionData where Base == String {
    func validate(with rules: ValidationRule..., message: String? = nil) -> ValidationResult {
        CombinedValidationRule(rules: rules, message: message).validate(base)
    }
    
    /// Method that returns type of `RulesContainer`.
    /// - Returns: Type of `RulesContainer`.
    func combine() -> RulesContainer {
        RulesContainer(text: base)
    }
    
    /// Validates whether the given text not empty.
    /// - Parameter message:Optional invalid validation message.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
    func notEmpty(message: String? = nil) -> ValidationResult {
        NotEmptyValidationRule(message: message).validate(base)
    }
    
    /// Validates whether the given text is an email.
    /// - Parameter message: Optional invalid validation message.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
    func isEmail(message: String? = nil) -> ValidationResult {
        IsEmailValidationRule(message: message).validate(base)
    }
    
    /// Validates whether the given text is a phone number.
    /// - Parameter message: Optional invalid validation message.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
    func isPhone(message: String? = nil) -> ValidationResult {
        IsPhoneValidationRule(message: message).validate(base)
    }
    
    /// Methods takes a closure `(String) -> Bool` as a parameter and validates given text by it.
    /// - Parameters:
    ///   - closure: Closure to validate.
    ///   - message: Optional invalid validation message.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
    func validByClosure(_ closure: @escaping ByClosureValidationRule.Closure, message: String?) -> ValidationResult {
        ByClosureValidationRule(closure: closure, message: message).validate(base)
    }
    
    /// Validates whether the given text contains regex.
    /// - Parameters:
    ///   - regex: Regex that given string should contain.
    ///   - message: Optional invalid validation message.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
    func matchRegex(_ regex: String, message: String? = nil) -> ValidationResult {
        RegexValidationRule(pattern: regex, message: message).validate(base)
    }
    
    /// Validates whether the given text has the lengh less than the given one.
    /// - Parameters:
    ///   - value: Lengh to check.
    ///   - message: optional validation message.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
    func lengthLessThan(_ value: Int, message: String? = nil) -> ValidationResult {
        LengthRangeValidationRule(upperBound: value, upperBoundMessage: message).validate(base)
    }
    
    /// Validates whether the given text has the lengh more than the given one.
    /// - Parameters:
    ///   - value: Lengh to check.
    ///   - message: Optional validation message.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
    func lengthHigherThan(_ value: Int, message: String? = nil) -> ValidationResult {
        LengthRangeValidationRule(lowerBound: value, lowerBoundMessage: message).validate(base)
    }
    
    /// Validates whether the given text has the lengh in the given range.
    /// - Parameters:
    ///   - range: Given range to check.
    ///   - lowerBoundMessage: Optional invalid validation message if the text has lower length than validated one.
    ///   - upperBoundMessage: Optional invalid validation message if the text has bigger length than validated one.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
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
