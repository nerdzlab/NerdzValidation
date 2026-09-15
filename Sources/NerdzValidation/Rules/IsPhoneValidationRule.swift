//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Passes when the string looks like a phone number.
public class IsPhoneValidationRule: RegexValidationRule {

    private enum Constants {
        static let pattern = "^[0-9+]{0,1}+[0-9\\ \\(\\)]{5,30}$"
    }

    /// Creates the rule.
    /// - Parameter message: Optional message overriding the default.
    public init(message: String? = nil) {
        super.init(pattern: Constants.pattern, message: message ?? "Invalid email address")
    }
}
