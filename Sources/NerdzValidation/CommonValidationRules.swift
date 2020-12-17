//
//  File.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

public struct NotEmptyRule: ValidationRule {
    private var errorMessage: String
    
    public init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    public func check(text: String) -> String? {
        return text.isEmpty ? errorMessage : nil
    }
}

public struct ShouldBeInRangeRule: ValidationRule {
    private var lowerBoundErrorMessage: String
    private var upperBoundErrorMessage: String
    
    private(set) var lowerBound: Int
    private(set) var upperBound: Int
    
    public func check(text: String) -> String? {
        var result: String?
        
        if text.utf16.count < lowerBound {
            result = lowerBoundErrorMessage
        }
        else if text.utf16.count > upperBound {
            result = upperBoundErrorMessage
        }
        return result
    }
    
    public init(lowerBoundErrorMessage: String, upperBoundErrorMessage: String, lowerBound: Int, upperBound: Int) {
        self.upperBoundErrorMessage = upperBoundErrorMessage
        self.lowerBoundErrorMessage = lowerBoundErrorMessage
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
}

public struct RegexValidationRule: ValidationRule {
    private(set) var regexPattern: String
    private(set) var errorMessage: String
    
    public init(regexPattern: String, errorMessage: String) {
        self.regexPattern = regexPattern
        self.errorMessage = errorMessage
    }
    
    public func check(text: String) -> String? {
        var result: String?
        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            if regex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count)).count != 1 {
                result = errorMessage
            }
        }
        catch {
            result = errorMessage
        }
        return result
    }
}
