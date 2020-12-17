//
//  ValidationResult.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

struct ValidationResult {
    var errorMessage: String? = nil
    
    var isValid: Bool {
        return errorMessage == nil
    }
}
