//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Class that represents regex validation
public class RegexValidationRule: ValidationRule {
    
    public let pattern: String
    public let message: String
    
    /// Initialization method.
    /// - Parameters:
    ///   - pattern: Pattern to valide in given text.
    ///   - message: Optional invalid validation message.
    public init(pattern: String, message: String? = nil) {
        self.pattern = pattern
        self.message = message ?? "String do not match regular expression: `\(pattern)`"
    }
    
    /// Methods that validates given text.
    /// - Parameter text: Given text to validate. 
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func validate(_ text: String) -> ValidationResult {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))
            
            if results.count == 1 {
                return .valid
            }
            else {
                return.invalid(message: message)
            }
        }
        catch {
            return .invalid(message: error.localizedDescription)
        }
    }
}
