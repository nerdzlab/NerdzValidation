//
//  String+Validate.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

public extension String {
    
    var notEmpty: Bool {
        NotEmptyValidationRule().validateText(self).isValid
    }
    
    var isEmail: Bool {
        IsEmailValidationRule().validateText(self).isValid
    }
    
    func notEmpty(message: String? = nil) -> RulesContainer {
        RulesContainer(initialRule: NotEmptyValidationRule(message: message), text: self)    
    }
    
    func isEmail(message: String? = nil) -> RulesContainer {
        RulesContainer(initialRule: NotEmptyValidationRule(message: message), text: self)
    }
    
    func validByClosure(_ closure: @escaping ByClosureValidationRule.Closure, message: String?) -> RulesContainer {
        RulesContainer(initialRule: ByClosureValidationRule(closure: closure, message: message), text: self)
    }
    
    func matchRegex(_ regex: String, message: String? = nil) -> RulesContainer {
        RulesContainer(initialRule: RegexValidationRule(pattern: regex, message: message), text: self)
    }
    
    func lengthLessThan(_ value: Int, message: String? = nil) -> RulesContainer {
        RulesContainer(initialRule: LengthRangeValidationRule(upperBound: value, upperBoundMessage: message), text: self)
    }
    
    func lengthHigherThan(_ value: Int, message: String? = nil) -> RulesContainer {
        RulesContainer(initialRule: LengthRangeValidationRule(lowerBound: value, lowerBoundMessage: message), text: self)
    }
    
    func lengthInRange(
        _ range: Range<Int>, 
        lowerBoundMessage: String? = nil, 
        upperBoundMessage: String? = nil
    ) -> RulesContainer 
    {
        let rule = LengthRangeValidationRule(
            lowerBound: range.lowerBound, 
            upperBound: range.upperBound, 
            lowerBoundMessage: lowerBoundMessage, 
            upperBoundMessage: upperBoundMessage
        )
        
        return RulesContainer(initialRule: rule, text: self)
    }
}
