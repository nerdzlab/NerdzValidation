//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

public class IsEmailValidationRule: RegexValidationRule {
    
    private enum Constants {
        static let pattern = "^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$"
    }
    
    public init(message: String? = nil) {
        super.init(pattern: Constants.pattern, message: message ?? "Invalid email address")
    }
}
