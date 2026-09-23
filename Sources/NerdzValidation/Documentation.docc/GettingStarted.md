# Getting started

Validate a string in three steps: reach the `.nzv` namespace, add rules, read the result.

## Validate with a single rule

Every built in rule has a shortcut on `.nzv` that returns a ``ValidationResult`` immediately.

```swift
let result = "someEmail@gmail.com".nzv.isEmail()
if result.isValid {
    print("Looks like an email")
}
```

## Combine multiple rules

Call `combine()` to start a chain, add rules, then call `validate()` once.

```swift
let result = password.nzv
    .combine()
    .notEmpty(message: "Password is required")
    .lengthHigherThan(7, message: "Password is too short")
    .validate()
```

By default the messages of all failing rules are merged into one bulleted string. Pass
`shouldCombineErrorMessages: false` to return only the first failure, or pass a single
`message` to `validate(with:)` to replace every message when any rule fails.

## Write a custom rule

For inline logic, use a closure.

```swift
let result = code.nzv.validByClosure({ $0.count == 6 }, message: "Code must be 6 digits")
```

For reusable logic, conform a type to ``ValidationRule``.

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

## Read the result

``ValidationResult`` gives you a boolean and an optional message.

```swift
submitButton.isEnabled = result.isValid
errorLabel.text = result.message
```
