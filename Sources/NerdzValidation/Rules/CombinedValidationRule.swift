//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Evaluates several rules together and reports a single combined result.
///
/// When more than one rule fails, their messages are merged into one bulleted string, unless
/// ``shouldCombineErrorMessages`` is `false` or an overriding `message` was supplied.
public class CombinedValidationRule: ValidationRule {

    /// The rules evaluated in order.
    public let rules: [ValidationRule]
    /// Whether failing messages are merged into one string.
    public let shouldCombineErrorMessages: Bool
    private let message: String?

    /// Creates the rule.
    /// - Parameters:
    ///   - rules: The rules to evaluate.
    ///   - shouldCombineErrorMessages: Whether to merge failing messages.
    ///   - message: Optional message replacing individual messages when any rule fails.
    public init(rules: [ValidationRule], shouldCombineErrorMessages: Bool, message: String? = nil) {
        self.rules = rules
        self.shouldCombineErrorMessages = shouldCombineErrorMessages
        self.message = message
    }
    
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
            else if let message = messages.first, messages.count == 1 || !shouldCombineErrorMessages {
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
