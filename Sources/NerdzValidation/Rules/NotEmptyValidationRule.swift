//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Passes when the string is not empty.
public class NotEmptyValidationRule: ValidationRule {
    private enum Constants {
        static let defaultMessage = "String should not be empty"
    }

    /// The message returned when the string is empty.
    public let message: String

    /// Creates the rule.
    /// - Parameter message: Optional message overriding the default.
    public init(message: String? = nil) {
        self.message = message ?? Constants.defaultMessage
    }
    
    public func validate(_ text: String) -> ValidationResult {
        return text.isEmpty ? .invalid(message: message) : .valid
    }
}
