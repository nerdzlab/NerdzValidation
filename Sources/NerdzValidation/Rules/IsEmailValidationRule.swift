//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Passes when the string looks like an email address.
public class IsEmailValidationRule: RegexValidationRule {

    private enum Constants {
        static let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }

    /// Creates the rule.
    /// - Parameter message: Optional message overriding the default.
    public init(message: String? = nil) {
        super.init(pattern: Constants.pattern, message: message ?? "Invalid email address")
    }
}
