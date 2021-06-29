//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

public class ByClosureValidationRule: ValidationRule {
    public typealias Closure = (String) -> Bool
    
    private enum Constants {
        static let defaultMessage = "String is invalid"
    }
    
    public let closure: Closure
    public let message: String
    
    public init(closure: @escaping Closure, message: String? = nil) {
        self.closure = closure
        
        self.message = message ?? Constants.defaultMessage
    }
    
    public func validate(_ text: String) -> ValidationResult {
        if closure(text) {
            return .valid
        }
        else {
            return .invalid(message: message)
        }
    }
}
