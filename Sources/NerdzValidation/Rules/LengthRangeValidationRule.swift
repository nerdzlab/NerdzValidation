//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// Passes when the string length (in UTF-16 units) falls within the configured bounds.
///
/// Both bounds are inclusive and optional. Provide only one to check a single side.
public class LengthRangeValidationRule: ValidationRule {

    /// The message returned when the string is shorter than ``lowerBound``.
    public let lowerBoundMessage: String?
    /// The message returned when the string is longer than ``upperBound``.
    public let upperBoundMessage: String?

    /// The inclusive minimum length, or `nil` to skip the lower check.
    public let lowerBound: Int?
    /// The inclusive maximum length, or `nil` to skip the upper check.
    public let upperBound: Int?

    /// Creates the rule.
    /// - Parameters:
    ///   - lowerBound: The inclusive minimum length.
    ///   - upperBound: The inclusive maximum length.
    ///   - lowerBoundMessage: Optional message used when the string is too short.
    ///   - upperBoundMessage: Optional message used when the string is too long.
    public init(lowerBound: Int? = nil, upperBound: Int? = nil, lowerBoundMessage: String? = nil, upperBoundMessage: String? = nil) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        
        self.upperBoundMessage = upperBoundMessage ??
            upperBound.flatMap { "String should have less than \($0) characters" }
            
        self.lowerBoundMessage = lowerBoundMessage ??
            lowerBound.flatMap { "String should have more than \($0) characters" }
    }
    
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
