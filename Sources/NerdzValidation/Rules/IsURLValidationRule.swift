//
//  IsURLValidationRule.swift
//
//
//  Created by Roman Kovalchuk.
//

import Foundation

/// Passes when the string can be interpreted as a URL host.
///
/// Trims surrounding whitespace, rejects empty and whitespace-containing strings, and falls
/// back to a dotted-host heuristic when `URL(string:)` does not expose a host (Apple's URL
/// parser is permissive about schemes but strict about hosts).
public class IsURLValidationRule: ValidationRule {

    private enum Constants {
        static let defaultMessage = "Invalid URL"
    }

    /// The message returned when the string is not a valid URL.
    public let message: String

    /// Creates the rule.
    /// - Parameter message: Optional message overriding the default.
    public init(message: String? = nil) {
        self.message = message ?? Constants.defaultMessage
    }

    public func validate(_ text: String) -> ValidationResult {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty, !trimmed.contains(where: { $0.isWhitespace }) else {
            return .invalid(message: message)
        }

        if let url = URL(string: trimmed), url.host != nil {
            return .valid
        }

        if trimmed.contains(".") {
            return .valid
        }

        return .invalid(message: message)
    }
}
