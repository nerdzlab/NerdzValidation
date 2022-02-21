//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Model that describes a container of validation rules
public class RulesContainer {
    
    private var rules: [ValidationRule] = []
    private let text: String
    
    /// Initializes a rules  container for a specific text.
    /// - Parameter text: Text to validate.
    init(text: String) {
        self.text = text
    }
    
    /// Validates the gives text with an array of validation rules.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result
    public func validate() -> ValidationResult {
        CombinedValidationRule(rules: rules).validate(text)
    }
    
    /// Validates the given text with a specific validation rule.
    /// - Parameters:
    ///   - rule: Specific validation rule.
    ///   - message: Optional invalid validation message.
    /// - Returns: Type of self (`RulesContainer`).
    public func validate(with rule: ValidationRule, message: String? = nil) -> Self {
        rules.append(rule)
        return self
    }
    
    /// Validates whether the given text not empty.
    /// - Parameter message: Optional invalid validation message.
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func notEmpty(message: String? = nil) -> Self {
        validate(with: NotEmptyValidationRule(message: message))
    }
    
    /// Validates whether the given text is an email.
    /// - Parameter message: Optional invalid validation message.
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func isEmail(message: String? = nil) -> Self {
        validate(with: IsEmailValidationRule(message: message))
    }
    
    /// Validates whether the given text is a phone number.
    /// - Parameter message: Optional invalid validation message.
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func isPhone(message: String? = nil) -> Self {
        validate(with: IsPhoneValidationRule(message: message))
    }
    
    /// Functions takes a closure `(String) -> Bool` as a parameter and validates given text by it.
    /// - Parameters:
    ///   - closure: Closure to validate.
    ///   - message: Optional invalid validation message.
    /// - Returns: Either `true` or `false` depending on the validation result.
    public func validByClosure(_ closure: @escaping ByClosureValidationRule.Closure, message: String?) -> Self {
        validate(with: ByClosureValidationRule(closure: closure, message: message))
    }
    
    /// Validates whether the given text contains regex.
    /// - Parameters:
    ///   - regex: Regex that given string should contain.
    ///   - message: Optional invalid validation message.
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func matchRegex(_ regex: String, message: String? = nil) -> Self {
        validate(with: RegexValidationRule(pattern: regex, message: message))
    }
    
    /// Validates whether the given text has the lengh less than the given one.
    /// - Parameters:
    ///   - value: Lengh to check.
    ///   - message: Optional invalid validation message.
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func lengthLessThan(_ value: Int, message: String? = nil) -> Self {
        validate(with: LengthRangeValidationRule(upperBound: value, upperBoundMessage: message))
    }
    
    /// Validates whether the given text has the lengh more than the given one
    /// - Parameters:
    ///   - value: Lengh to check.
    ///   - message: Optional invalid validation message.
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func lengthHigherThan(_ value: Int, message: String? = nil) -> Self {
        validate(with: LengthRangeValidationRule(lowerBound: value, lowerBoundMessage: message))
    }
    
    /// Validates whether the given text has the lengh in the given range
    /// - Parameters:
    ///   - range: Given range to check.
    ///   - lowerBoundMessage: Optional invalid validation message if the text has lower length than validated one.
    ///   - upperBoundMessage: Optional invalid validation message if the text has bigger length than validated one.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
    public func lengthInRange(
        _ range: Range<Int>, 
        lowerBoundMessage: String? = nil, 
        upperBoundMessage: String? = nil
    ) -> Self 
    {
        let rule = LengthRangeValidationRule(
            lowerBound: range.lowerBound, 
            upperBound: range.upperBound, 
            lowerBoundMessage: lowerBoundMessage, 
            upperBoundMessage: upperBoundMessage
        )
        
        return validate(with: rule)
    }
}
