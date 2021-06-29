//
//  ValidationRule.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

public protocol ValidationRule {    
    func validate(_ text: String) -> ValidationResult
}
