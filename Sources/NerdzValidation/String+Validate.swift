//
//  String+Validate.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

public extension String {
    public func validate(with validationRules: [ValidationRule]) -> ValidationResult {
        return ValidationResult(errorMessage: validationRules.compactMap({ $0.check(text: self) }).first)
    }
}
