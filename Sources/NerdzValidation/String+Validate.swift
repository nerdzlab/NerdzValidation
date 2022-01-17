//
//  String+Validate.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

extension String: NZValidationExtensionCompatible { }

public extension NZValidationExtensionData where Base == String {
    func validate(with rules: ValidationRule..., message: String? = nil) -> ValidationResult {
        CombinedValidationRule(rules: rules, message: message).validate(base)
    }
    
    func combine() -> RulesContainer {
        RulesContainer(text: base)
    }
    
    func notEmpty(message: String? = nil) -> ValidationResult {
        NotEmptyValidationRule(message: message).validate(base)
    }
    
    func isEmail(message: String? = nil) -> ValidationResult {
        IsEmailValidationRule(message: message).validate(base)
    }
    
    func isPhone(message: String? = nil) -> ValidationResult {
        IsPhoneValidationRule(message: message).validate(base)
    }
    
    func validByClosure(_ closure: @escaping ByClosureValidationRule.Closure, message: String?) -> ValidationResult {
        ByClosureValidationRule(closure: closure, message: message).validate(base)
    }
    
    func matchRegex(_ regex: String, message: String? = nil) -> ValidationResult {
        RegexValidationRule(pattern: regex, message: message).validate(base)
    }
    
    func lengthLessThan(_ value: Int, message: String? = nil) -> ValidationResult {
        LengthRangeValidationRule(upperBound: value, upperBoundMessage: message).validate(base)
    }
    
    func lengthHigherThan(_ value: Int, message: String? = nil) -> ValidationResult {
        LengthRangeValidationRule(lowerBound: value, lowerBoundMessage: message).validate(base)
    }
    
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
