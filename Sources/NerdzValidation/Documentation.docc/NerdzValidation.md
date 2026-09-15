# ``NerdzValidation``

Validate strings declaratively by composing small, reusable validation rules.

## Overview

NerdzValidation exposes a fluent `.nzv` namespace on `String`. You can run a single rule,
combine several rules into one result, and control how error messages are reported. Every rule
conforms to the small ``ValidationRule`` protocol, so adding your own is straightforward.

```swift
import NerdzValidation

let result = "someEmail@gmail.com".nzv
    .combine()
    .notEmpty()
    .isEmail()
    .lengthInRange(4..<200)
    .validate()

print(result.isValid)      // true
print(result.message ?? "") // "" when valid
```

## Topics

### Getting started

- <doc:GettingStarted>

### Core types

- ``ValidationRule``
- ``ValidationResult``
- ``RulesContainer``

### Built in rules

- ``NotEmptyValidationRule``
- ``IsEmailValidationRule``
- ``IsPhoneValidationRule``
- ``IsURLValidationRule``
- ``RegexValidationRule``
- ``LengthRangeValidationRule``
- ``ByClosureValidationRule``
- ``CombinedValidationRule``

### Extending String

- ``NZValidationExtensionCompatible``
- ``NZValidationExtensionData``
