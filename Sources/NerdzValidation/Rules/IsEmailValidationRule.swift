//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

public class IsEmailValidationRule: RegexValidationRule {
    
    private enum Constants {
        static let pattern = "[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}"
    }
    
    public init(message: String? = nil) {
        super.init(pattern: Constants.pattern, message: message ?? "Invalid email address")
    }
}
