//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Passes when the string matches a regular expression pattern.
public class RegexValidationRule: ValidationRule {

    /// The regular expression pattern to match against.
    public let pattern: String
    /// The message returned when the string does not match.
    public let message: String

    /// Creates the rule.
    /// - Parameters:
    ///   - pattern: The regular expression pattern.
    ///   - message: Optional message overriding the default.
    public init(pattern: String, message: String? = nil) {
        self.pattern = pattern
        self.message = message ?? "String do not match regular expression: `\(pattern)`"
    }
    
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
