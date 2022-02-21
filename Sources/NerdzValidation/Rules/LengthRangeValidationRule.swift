//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Class that represents phone validation rule.
public class LengthRangeValidationRule: ValidationRule {
    
    /// Value that represents lower bound message.
    public let lowerBoundMessage: String?
    /// Value that represents upper bound message.
    public let upperBoundMessage: String?
    
    /// Value that represents lower bound value.
    public let lowerBound: Int?
    /// Value that represents upper bound value.
    public let upperBound: Int?
    
    /// Initialization method.
    /// - Parameters:
    ///   - lowerBound: Lower bound of lenght validation.
    ///   - upperBound: Upper bound of lenght validation.
    ///   - lowerBoundMessage: Optional lower bound invalid message.
    ///   - upperBoundMessage: Optional upper bound invalid message.
    public init(lowerBound: Int? = nil, upperBound: Int? = nil, lowerBoundMessage: String? = nil, upperBoundMessage: String? = nil) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        
        self.upperBoundMessage = upperBoundMessage ??
            upperBound.flatMap { "String should have less than \($0) characters" }
            
        self.lowerBoundMessage = lowerBoundMessage ??
            lowerBound.flatMap { "String should have more than \($0) characters" }
    }
    
    /// Methods that validates given text.
    /// - Parameter text: Given text to validate.
    /// - Returns: Either `.valid` or   `.invalid` with optional message depending on the validation result.
    public func validate(_ text: String) -> ValidationResult  {
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
