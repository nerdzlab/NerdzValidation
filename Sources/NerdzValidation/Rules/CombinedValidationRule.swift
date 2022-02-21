//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Class that represents validation rule that can contain another rules inside it.
public class CombinedValidationRule: ValidationRule {
    
    /// An array or type `ValidationRule`, contains all rules to validate text.
    public let rules: [ValidationRule]
    
    private let message: String?
    
    /// Initialization method.
    /// - Parameters:
    ///   - rules: An array of type `ValidationRule`.
    ///   - message: Optional invalid validation message.
    public init(rules: [ValidationRule], message: String? = nil) {
        self.rules = rules
        self.message = message
    }
    
    /// Methods that validates given text.
    /// - Parameter text: Given text to validate.
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func validate(_ text: String) -> ValidationResult {
        if let message = message, rules.contains(where: { !$0.validate(text).isValid }) {
            return .invalid(message: message)
        }
        else {
            let messages: [String] = rules.compactMap {
                let result = $0.validate(text)
                
                if case .invalid(let message) = result {
                    return message
                }
                else {
                    return nil
                }
            }
            
            if messages.isEmpty {
                return .valid
            }
            else if let message = messages.first, messages.count == 1 {
                return .invalid(message: message)
            }
            else {
                let message = messages.reduce(into: "") {
                    $0 += "- \($1)\n"
                }
                
                return .invalid(message: message)
            }
        }
    }
}
