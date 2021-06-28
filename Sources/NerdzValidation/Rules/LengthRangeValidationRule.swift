//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

public class LengthRangeValidationRule: ValidationRule {
    
    public let lowerBoundMessage: String
    public let upperBoundMessage: String
    
    public let lowerBound: Int?
    public let upperBound: Int?
    
    public init(lowerBound: Int? = nil, upperBound: Int? = nil, lowerBoundMessage: String? = nil, upperBoundMessage: String? = nil) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        
        self.upperBoundMessage = upperBoundMessage ??
            "String should have less than \(upperBound) characters"
            
        self.lowerBoundMessage = lowerBoundMessage ??
            "String should have more than \(lowerBound) characters"
    }
    
    public func validateText(_ text: String) -> ValidationResult  {
        if let bound = lowerBound, text.utf16.count < bound {
            return .invalid(message: lowerBoundMessage)
        }
        else if let bound = upperBound, text.utf16.count > bound {
            return .invalid(message: upperBoundMessage)
        }
        else {
            return .valid
        }
    }
}