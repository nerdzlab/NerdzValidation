//
//  ValidationResult.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

/// The outcome of validating a string.
///
/// Use ``isValid`` for a quick boolean check and ``message`` to display the failure reason.
public enum ValidationResult: Sendable, Equatable {
    /// The string passed validation.
    case valid
    /// The string failed validation, optionally carrying a human readable reason.
    case invalid(message: String? = nil)

    /// `true` when the result is ``valid``.
    public var isValid: Bool {
        if case .valid = self {
            return true
        }
        else {
            return false
        }
    }
    
    /// The failure message for an ``invalid(message:)`` result, or `nil` when ``valid``.
    public var message: String? {
        if case .invalid(let message) = self {
            return message
        }
        else {
            return nil
        }
    }
}
