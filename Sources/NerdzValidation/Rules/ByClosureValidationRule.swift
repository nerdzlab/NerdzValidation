//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Class that represents validation by closure
public class ByClosureValidationRule: ValidationRule {
    public typealias Closure = (String) -> Bool
    
    private enum Constants {
        static let defaultMessage = "String is invalid"
    }
    
    /// Given closure of type `(String) -> Bool`.
    public let closure: Closure
    /// Validation message.
    public let message: String
    
    /// Initialization method.
    /// - Parameters:
    ///   - closure: Validation closure of type `(String) -> Bool`
    ///   - message: Optional invalid validation message.
    public init(closure: @escaping Closure, message: String? = nil) {
        self.closure = closure
        
        self.message = message ?? Constants.defaultMessage
    }
    
    /// Methods for validation given text.
    /// - Parameter text: Given text to validate.
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func validate(_ text: String) -> ValidationResult {
        if closure(text) {
            return .valid
        }
        else {
            return .invalid(message: message)
        }
    }
}
