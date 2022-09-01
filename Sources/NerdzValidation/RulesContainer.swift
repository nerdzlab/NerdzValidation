//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

public class RulesContainer {
    
    private var rules: [ValidationRule] = []
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    public func validate(with message: String? = nil) -> ValidationResult {
        CombinedValidationRule(rules: rules, message: message).validate(text)
    }
    
    public func validate(with rule: ValidationRule, message: String? = nil) -> Self {
        rules.append(rule)
        return self
    }
    
    public func notEmpty(message: String? = nil) -> Self {
        validate(with: NotEmptyValidationRule(message: message))
    }
    
    public func isEmail(message: String? = nil) -> Self {
        validate(with: IsEmailValidationRule(message: message))
    }
    
    public func isPhone(message: String? = nil) -> Self {
        validate(with: IsPhoneValidationRule(message: message))
    }
    
    public func validByClosure(_ closure: @escaping ByClosureValidationRule.Closure, message: String?) -> Self {
        validate(with: ByClosureValidationRule(closure: closure, message: message))
    }
    
    public func matchRegex(_ regex: String, message: String? = nil) -> Self {
        validate(with: RegexValidationRule(pattern: regex, message: message))
    }
    
    public func lengthLessThan(_ value: Int, message: String? = nil) -> Self {
        validate(with: LengthRangeValidationRule(upperBound: value, upperBoundMessage: message))
    }
    
    public func lengthHigherThan(_ value: Int, message: String? = nil) -> Self {
        validate(with: LengthRangeValidationRule(lowerBound: value, lowerBoundMessage: message))
    }
    
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
