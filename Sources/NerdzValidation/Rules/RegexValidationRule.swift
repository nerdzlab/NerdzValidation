//
//  File.swift
//
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Passes when the string matches a regular expression pattern.
///
/// The pattern is compiled once at initialization and reused for every validation, so repeated
/// validation (for example on each keystroke) does not recompile the expression.
///
/// - Note: This type is not `final` because ``IsEmailValidationRule`` and
///   ``IsPhoneValidationRule`` subclass it, so it is marked `@unchecked Sendable`. The safety
///   invariant holds: all stored properties are immutable and `NSRegularExpression` is
///   documented as thread-safe.
public class RegexValidationRule: ValidationRule, @unchecked Sendable {

    /// The regular expression pattern to match against.
    public let pattern: String
    /// The message returned when the string does not match.
    public let message: String

    private let regex: NSRegularExpression?

    /// Creates the rule.
    /// - Parameters:
    ///   - pattern: The regular expression pattern.
    ///   - message: Optional message overriding the default.
    public init(pattern: String, message: String? = nil) {
        self.pattern = pattern
        self.message = message ?? "String do not match regular expression: `\(pattern)`"
        self.regex = try? NSRegularExpression(pattern: pattern)
    }

    public func validate(_ text: String) -> ValidationResult {
        // A nil `regex` means the pattern failed to compile, so nothing can match it.
        guard let regex else {
            return .invalid(message: message)
        }

        let fullRange = NSRange(location: 0, length: text.utf16.count)

        // The string is valid only when the pattern matches it in full, so trailing or leading
        // text that does not belong to the pattern is rejected.
        if let match = regex.firstMatch(in: text, range: fullRange), match.range == fullRange {
            return .valid
        }
        else {
            return .invalid(message: message)
        }
    }
}
