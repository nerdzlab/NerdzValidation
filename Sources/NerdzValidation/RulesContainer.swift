//
//  File.swift
//  
//
//  Created by new user on 28.06.2021.
//

import Foundation

/// A mutable builder that collects validation rules and evaluates them together.
///
/// Obtain a container with `String.nzv.combine()`, chain rules, then call
/// ``validate(with:shouldCombineErrorMessages:)`` to produce a single ``ValidationResult``.
///
/// ```swift
/// let result = email.nzv
///     .combine()
///     .notEmpty()
///     .isEmail()
///     .validate()
/// ```
public class RulesContainer {

    // MARK: - Properties(private)

    private var rules: [ValidationRule] = []
    private let text: String

    // MARK: - Life cycle

    /// Creates a container for the given text.
    /// - Parameter text: The string that the collected rules validate.
    init(text: String) {
        self.text = text
    }

    // MARK: - Methods(public)

    /// Evaluates all collected rules and returns the combined result.
    ///
    /// - Parameters:
    ///   - message: An optional message that replaces every individual rule message when any
    ///     rule fails.
    ///   - shouldCombineErrorMessages: When `true` (the default), the messages of all failing
    ///     rules are merged into one bulleted string. When `false`, only the first failing
    ///     message is returned.
    /// - Returns: The combined ``ValidationResult``.
    public func validate(with message: String? = nil, shouldCombineErrorMessages: Bool = true) -> ValidationResult {
        CombinedValidationRule(rules: rules, shouldCombineErrorMessages: shouldCombineErrorMessages, message: message).validate(text)
    }

    /// Appends a rule to the chain.
    ///
    /// - Parameters:
    ///   - rule: The ``ValidationRule`` to add.
    ///   - message: Currently unused. Reserved for a future per-rule message override; pass the
    ///     message to the rule's own initializer instead.
    /// - Returns: The same container, so calls can be chained.
    public func validate(with rule: ValidationRule, message: String? = nil) -> Self {
        rules.append(rule)
        return self
    }

    /// Adds a rule requiring the string to be non empty.
    /// - Parameter message: Optional message overriding the default.
    /// - Returns: The same container, so calls can be chained.
    public func notEmpty(message: String? = nil) -> Self {
        validate(with: NotEmptyValidationRule(message: message))
    }

    /// Adds a rule requiring the string to look like an email address.
    /// - Parameter message: Optional message overriding the default.
    /// - Returns: The same container, so calls can be chained.
    public func isEmail(message: String? = nil) -> Self {
        validate(with: IsEmailValidationRule(message: message))
    }

    /// Adds a rule requiring the string to look like a phone number.
    /// - Parameter message: Optional message overriding the default.
    /// - Returns: The same container, so calls can be chained.
    public func isPhone(message: String? = nil) -> Self {
        validate(with: IsPhoneValidationRule(message: message))
    }

    /// Adds a rule requiring the string to be interpretable as a URL host.
    /// - Parameter message: Optional message overriding the default.
    /// - Returns: The same container, so calls can be chained.
    public func isURL(message: String? = nil) -> Self {
        validate(with: IsURLValidationRule(message: message))
    }

    /// Adds a rule that passes when the closure returns `true`.
    /// - Parameters:
    ///   - closure: The predicate to evaluate against the string.
    ///   - message: Message used when the closure returns `false`.
    /// - Returns: The same container, so calls can be chained.
    public func validByClosure(_ closure: @escaping ByClosureValidationRule.Closure, message: String?) -> Self {
        validate(with: ByClosureValidationRule(closure: closure, message: message))
    }

    /// Adds a rule requiring the string to match a regular expression.
    /// - Parameters:
    ///   - regex: The regular expression pattern.
    ///   - message: Optional message overriding the default.
    /// - Returns: The same container, so calls can be chained.
    public func matchRegex(_ regex: String, message: String? = nil) -> Self {
        validate(with: RegexValidationRule(pattern: regex, message: message))
    }

    /// Adds a rule requiring the string to be shorter than `value` UTF-16 units.
    /// - Parameters:
    ///   - value: The exclusive upper bound.
    ///   - message: Optional message overriding the default.
    /// - Returns: The same container, so calls can be chained.
    public func lengthLessThan(_ value: Int, message: String? = nil) -> Self {
        validate(with: LengthRangeValidationRule(upperBound: value, upperBoundMessage: message))
    }

    /// Adds a rule requiring the string to be longer than `value` UTF-16 units.
    /// - Parameters:
    ///   - value: The exclusive lower bound.
    ///   - message: Optional message overriding the default.
    /// - Returns: The same container, so calls can be chained.
    public func lengthHigherThan(_ value: Int, message: String? = nil) -> Self {
        validate(with: LengthRangeValidationRule(lowerBound: value, lowerBoundMessage: message))
    }

    /// Adds a rule requiring the string length to fall within a range.
    /// - Parameters:
    ///   - range: The allowed length range in UTF-16 units.
    ///   - lowerBoundMessage: Optional message used when the string is too short.
    ///   - upperBoundMessage: Optional message used when the string is too long.
    /// - Returns: The same container, so calls can be chained.
    public func lengthInRange(
        _ range: Range<Int>, 
        lowerBoundMessage: String? = nil, 
        upperBoundMessage: String? = nil
    ) -> Self 
    {
        let rule = LengthRangeValidationRule(
            lowerBound: range.lowerBound, 
            upperBound: range.upperBound, 
            lowerBoundMessage: lowerBoundMessage, 
            upperBoundMessage: upperBoundMessage
        )
        
        return validate(with: rule)
    }
}
