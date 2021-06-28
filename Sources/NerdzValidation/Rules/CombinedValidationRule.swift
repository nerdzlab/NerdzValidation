//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

public class CombinedValidationRule: ValidationRule {
    
    public let rules: [ValidationRule]
    
    private let message: String?
    
    public init(rules: [ValidationRule], message: String? = nil) {
        self.rules = rules
        self.message = message
    }
    
    public func validateText(_ text: String) -> ValidationResult {
        if let message = message, rules.contains(where: { !$0.validateText(text).isValid }) {
            return .invalid(message: message)
        }
        else {
            let messages: [String] = rules.compactMap {
                let result = $0.validateText(text)
                
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
