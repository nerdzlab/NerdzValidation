//
//  ValidationRule.swift
//  
//
//  Created by Roman Kovalchuk on 17.12.2020.
//

import Foundation

/// A single, reusable check that a string either passes or fails.
///
/// Conform your own types to `ValidationRule` to plug custom logic into the `.nzv` API.
///
/// ```swift
/// struct StartsWithCapitalRule: ValidationRule {
///     func validate(_ text: String) -> ValidationResult {
///         guard let first = text.first else { return .invalid(message: "String is empty") }
///         return first.isUppercase ? .valid : .invalid(message: "Must start with a capital letter")
///     }
/// }
/// ```
public protocol ValidationRule {
    /// Validates the given text and returns the outcome.
    ///
    /// - Parameter text: The string to validate.
    /// - Returns: ``ValidationResult/valid`` when the text passes, otherwise
    ///   ``ValidationResult/invalid(message:)`` carrying a failure message.
    func validate(_ text: String) -> ValidationResult
}
