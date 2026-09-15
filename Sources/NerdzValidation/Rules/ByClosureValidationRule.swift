//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Passes when a custom closure returns `true` for the string.
public class ByClosureValidationRule: ValidationRule {
    /// A predicate that returns `true` when the string is valid.
    public typealias Closure = (String) -> Bool

    private enum Constants {
        static let defaultMessage = "String is invalid"
    }

    /// The predicate evaluated during validation.
    public let closure: Closure
    /// The message returned when the closure returns `false`.
    public let message: String

    /// Creates the rule.
    /// - Parameters:
    ///   - closure: The predicate to evaluate.
    ///   - message: Optional message overriding the default.
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
