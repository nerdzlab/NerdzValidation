//
//  String+Validate.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

public extension String {
    
    func validate(with rules: ValidationRule..., message: String? = nil) -> ValidationResult {
        CombinedValidationRule(rules: rules, message: message).validateText(self)
    }
    
    func combine() -> RulesContainer {
        RulesContainer(text: self)
    }
    
    func notEmpty(message: String? = nil) -> ValidationResult {
        NotEmptyValidationRule(message: message).validateText(self)    
    }
    
    func isEmail(message: String? = nil) -> ValidationResult {
        IsEmailValidationRule(message: message).validateText(self)
    }
    
    func isPhone(message: String? = nil) -> ValidationResult {
        IsPhoneValidationRule(message: message).validateText(self)
    }
    
    func validByClosure(_ closure: @escaping ByClosureValidationRule.Closure, message: String?) -> ValidationResult {
        ByClosureValidationRule(closure: closure, message: message).validateText(self)
    }
    
    func matchRegex(_ regex: String, message: String? = nil) -> ValidationResult {
        RegexValidationRule(pattern: regex, message: message).validateText(self)
    }
    
    func lengthLessThan(_ value: Int, message: String? = nil) -> ValidationResult {
        LengthRangeValidationRule(upperBound: value, upperBoundMessage: message).validateText(self)
    }
    
    func lengthHigherThan(_ value: Int, message: String? = nil) -> ValidationResult {
        LengthRangeValidationRule(lowerBound: value, lowerBoundMessage: message).validateText(self)
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
        
        return rule.validateText(self)
    }
}
