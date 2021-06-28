//
//  ValidationResult.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

public enum ValidationResult {
    case valid
    case invalid(message: String? = nil)
    
    public var isValid: Bool {
        if case .valid = self {
            return true
        }
        else {
            return false
        }
    }
    
    public var message: String? {
        if case .invalid(let message) = self {
            return message
        }
        else {
            return nil
        }
    }
}
