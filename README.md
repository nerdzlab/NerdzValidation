# NerdzValidation

> Validate strings declaratively by composing small, reusable validation rules.

[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![CocoaPods](https://img.shields.io/badge/pod-NerdzValidation-blue.svg)](https://cocoapods.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2012%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-black.svg)](LICENSE)

NerdzValidation lets you validate text through a fluent `.nzv` namespace on `String`. You can
run a single rule, combine several rules, and control how error messages are reported. Every
rule conforms to a tiny `ValidationRule` protocol, so writing your own is trivial.

## Requirements

The library runs on iOS 12 and later (and any Apple platform, since it depends only on
Foundation). Building it requires Xcode 15 or later (Swift tools 5.9), which the Swift Testing
based test suite needs. The runtime deployment target is unaffected.

## Installation

### Swift Package Manager

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nerdzlab/NerdzValidation.git", from: "2.1.0")
]
```

Or in Xcode, choose File, Add Package Dependencies, and paste the repository URL.

### CocoaPods

Add this line to your `Podfile` and run `pod install`:

```ruby
pod 'NerdzValidation'
```

## Quick start

Import the module and validate through the `.nzv` namespace.

```swift
import NerdzValidation

// A single rule.
let emailResult = "someEmail@gmail.com".nzv.isEmail()
print(emailResult.isValid) // true

// Several rules combined into one result.
let result = "someEmail@gmail.com".nzv
    .combine()
    .notEmpty()
    .isEmail()
    .lengthInRange(4..<200)
    .validate()

if result.isValid {
    print("All good")
} else {
    print(result.message ?? "Invalid")
}
```

## Built in rules

Each rule is available both as a one shot shortcut on `.nzv` and as a chainable method on the
container returned by `combine()`.

| Rule | Shortcut | Container method | Default message |
| --- | --- | --- | --- |
| Not empty | `.nzv.notEmpty()` | `.notEmpty()` | "String should not be empty" |
| Email | `.nzv.isEmail()` | `.isEmail()` | "Invalid email address" |
| Phone | `.nzv.isPhone()` | `.isPhone()` | (phone number message) |
| URL | `.nzv.isURL()` | `.isURL()` | "Invalid URL" |
| Regex | `.nzv.matchRegex(_:)` | `.matchRegex(_:)` | "String do not match regular expression: ..." |
| Length below | `.nzv.lengthLessThan(_:)` | `.lengthLessThan(_:)` | "String should have less than N characters" |
| Length above | `.nzv.lengthHigherThan(_:)` | `.lengthHigherThan(_:)` | "String should have more than N characters" |
| Length range | `.nzv.lengthInRange(_:)` | `.lengthInRange(_:)` | (per bound messages) |
| Custom closure | `.nzv.validByClosure(_:message:)` | `.validByClosure(_:message:)` | "String is invalid" |

Every method accepts an optional `message:` argument to override the default text.

## Combining rules

Call `combine()` to start a chain, add as many rules as you need, then call `validate()`.

```swift
let password = "hunter2".nzv
    .combine()
    .notEmpty(message: "Password is required")
    .lengthHigherThan(7, message: "Password is too short")
    .validate()
```

### Controlling error messages

By default, when several rules fail their messages are merged into a single bulleted string.
Pass `shouldCombineErrorMessages: false` to return only the first failing message.

```swift
let result = value.nzv
    .combine()
    .notEmpty()
    .isEmail()
    .validate(shouldCombineErrorMessages: false)
```

You can also pass a single overriding `message` that replaces all individual messages when any
rule fails.

```swift
let result = value.nzv
    .combine()
    .notEmpty()
    .isEmail()
    .validate(with: "Please enter a valid email address")
```

### Validating against a pre-built array of rules

When the rules are assembled elsewhere (for example, vended by a use case or view model), pass
them as an array. Error messages are not merged by default, so only the first failing message
is returned. Pass `shouldCombineErrorMessages: true` to merge them.

```swift
func makeURLValidationRules() -> [ValidationRule] {
    [
        NotEmptyValidationRule(message: "Field should not be empty"),
        IsURLValidationRule(message: "Invalid URL")
    ]
}

let result = urlText.nzv.validate(with: makeURLValidationRules())
```

### Any-of and negation

By default a chain requires every rule to pass. Use `any(of:)` to accept a value that matches
at least one of several rules, and `not(_:)` to invert a rule.

```swift
// Accepts either a valid email or a valid phone.
let contact = value.nzv
    .combine()
    .notEmpty()
    .any(of: [IsEmailValidationRule(), IsPhoneValidationRule()])
    .validate()

// Rejects a reserved word.
let username = value.nzv
    .combine()
    .not(ByClosureValidationRule(closure: { $0 == "admin" }, message: nil), message: "Reserved name")
    .validate()
```

## Custom rules

For one off logic, use a closure.

```swift
let result = username.nzv.validByClosure({ text in
    text.allSatisfy { $0.isLetter || $0.isNumber }
}, message: "Only letters and numbers are allowed")
```

For reusable logic, conform a type to `ValidationRule`.

```swift
struct StartsWithCapitalRule: ValidationRule {
    func validate(_ text: String) -> ValidationResult {
        guard let first = text.first else {
            return .invalid(message: "String is empty")
        }
        return first.isUppercase ? .valid : .invalid(message: "Must start with a capital letter")
    }
}

let result = name.nzv.validate(with: StartsWithCapitalRule())
```

## Working with the result

`validate()` returns a `ValidationResult` enum with two convenience accessors.

```swift
let result = field.text?.nzv.combine().notEmpty().isEmail().validate() ?? .valid

textField.errorLabel.text = result.message
submitButton.isEnabled = result.isValid
```

`result.isValid` is `true` for a passing validation, and `result.message` holds the failure
text (or `nil` when valid).

## Documentation

Full API reference is available through DocC. In Xcode, choose Product, Build Documentation, or
build it from the command line with `swift package generate-documentation`.

## License

NerdzValidation is available under the MIT license. See the [LICENSE](LICENSE) file for details.
