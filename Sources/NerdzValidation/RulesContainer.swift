//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

public class RulesContainer {
    
    private var rules: [ValidationRule]
    private let text: String
    
    init(initialRule: ValidationRule? = nil, text: String) {
        rules = initialRule.flatMap { [$0] } ?? []
        self.text = text
    }
    
    public func validate() -> ValidationResult {
        CombinedValidationRule(rules: rules).validateText(text)
    }
    
    public func notEmpty(message: String? = nil) -> Self {
        rules.append(NotEmptyValidationRule(message: message))
        return self
    }
    
    public func isEmail(message: String? = nil) -> Self {
        rules.append(IsEmailValidationRule(message: message))
        return self
    }
    
    public func isPhone(message: String? = nil) -> Self {
        rules.append(IsPhoneValidationRule(message: message))
        return self
    }
    
    public func validByClosure(_ closure: @escaping ByClosureValidationRule.Closure, message: String?) -> Self {
        rules.append(ByClosureValidationRule(closure: closure, message: message))
        return self
    }
    
    public func matchRegex(_ regex: String, message: String? = nil) -> Self {
        rules.append(RegexValidationRule(pattern: regex, message: message))
        return self
    }
    
    public func lengthLessThan(_ value: Int, message: String? = nil) -> Self {
        rules.append(LengthRangeValidationRule(upperBound: value, upperBoundMessage: message))
        return self
    }
    
    public func lengthHigherThan(_ value: Int, message: String? = nil) -> Self {
        rules.append(LengthRangeValidationRule(lowerBound: value, lowerBoundMessage: message))
        return self
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
        
        rules.append(rule)
        return self
    }
}
