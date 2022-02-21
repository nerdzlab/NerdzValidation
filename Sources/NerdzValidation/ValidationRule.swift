//
//  ValidationRule.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

// Protocol that describes methods for text validation.
public protocol ValidationRule {    
    func validate(_ text: String) -> ValidationResult
}
