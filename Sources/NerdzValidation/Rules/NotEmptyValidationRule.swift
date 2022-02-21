//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Class that represents empty text validation rule.
public class NotEmptyValidationRule: ValidationRule {
    private enum Constants {
        static let defaultMessage = "String should not be empty"
    }
    
    /// Validation message.
    public let message: String
    
    
    /// Initialization method.
    /// - Parameter message: Optional invalid validation message.
    public init(message: String? = nil) {
        self.message = message ?? Constants.defaultMessage
    }
    
    /// Methods that validates given text.
    /// - Parameter text: Given text to validate.
    /// - Returns: Either `valid` or   `invalid` with optional message depending on the validation result.
    public func validate(_ text: String) -> ValidationResult {
        return text.isEmpty ? .invalid(message: message) : .valid
    }
}
