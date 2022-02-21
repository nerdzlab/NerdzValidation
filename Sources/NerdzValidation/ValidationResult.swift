//
//  ValidationResult.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

/// Model representing validation result
public enum ValidationResult {
    
    /// Case that describes successful validation.
    case valid
    /// Case that describes unsuccessful validation with optional message.
    case invalid(message: String? = nil)
    
    /// Value that describes whether the validation is successful. Can be either `true` or `false`.
    public var isValid: Bool {
        if case .valid = self {
            return true
        }
        else {
            return false
        }
    }
    
    /// Value that describes messages if validation is invalid.
    public var message: String? {
        if case .invalid(let message) = self {
            return message
        }
        else {
            return nil
        }
    }
}
