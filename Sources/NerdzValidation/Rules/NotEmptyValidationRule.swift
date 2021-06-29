//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

public class NotEmptyValidationRule: ValidationRule {
    private enum Constants {
        static let defaultMessage = "String should not be empty"
    }
    
    public let message: String
    
    public init(message: String? = nil) {
        self.message = message ?? Constants.defaultMessage
    }
    
    public func validate(_ text: String) -> ValidationResult {
        return text.isEmpty ? .invalid(message: message) : .valid
    }
}
