//
//  ValidationResult.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

public struct ValidationResult {
    public var errorMessage: String? = nil
    
    public var isValid: Bool {
        return errorMessage == nil
    }
}
