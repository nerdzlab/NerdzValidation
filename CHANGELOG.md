# Changelog

All notable changes to NerdzValidation are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0]

### Added
- Array based `validate(with rules: [ValidationRule], shouldCombineErrorMessages:message:)` overload on the `.nzv` String namespace, so pre-built rule arrays (for example vended by a use case) can be validated without a variadic call. Error messages are not merged by default.
- `IsURLValidationRule` plus `.nzv.isURL()` and the container `isURL()` method, validating that a string can be interpreted as a URL host.
- `OrValidationRule` (any-of) and `NotValidationRule` (negation) combinators, plus container `any(of:)` and `not(_:)` conveniences.
- `Sendable` conformance across the public API (`ValidationResult`, `ValidationRule`, and the rules) for use under Swift 6 strict concurrency, and `Equatable` conformance on `ValidationResult`.
- Rewritten README that documents the real `.nzv` API with working installation, quick start, rule table, and usage examples.
- Swift Testing target (`NerdzValidationTests`) covering every rule, the rules container, the result type, and the `.nzv` String extension (around 99% line coverage).
- DocC documentation catalog with a landing page, a Getting Started article, and reference docs on all public symbols.

### Changed
- `RegexValidationRule` (and its `IsEmail`/`IsPhone`/`IsURL` relatives) now compile their regular expression once at initialization instead of on every `validate(_:)` call.
- `ValidationRule` now refines `Sendable`. Custom rules conforming to it must also be `Sendable` (a pure predicate rule already is). `ByClosureValidationRule`'s closure is now `@Sendable`.
- `Package.swift` `swift-tools-version` raised from 5.3 to 5.9 to support Swift Testing. The runtime deployment target is unchanged (tests are not shipped). Building the package now requires Xcode 15 or later.

### Removed
- CocoaPods support. The podspec has been deleted and the library is now distributed through Swift Package Manager only. Projects that installed NerdzValidation with CocoaPods must migrate to SPM.

### Fixed
- `IsPhoneValidationRule` returned "Invalid email address" as its default failure message. It now returns "Invalid phone number".
- `CombinedValidationRule` evaluated each rule twice when a container level message was set. Rules are now evaluated exactly once. Output is unchanged.
- `RegexValidationRule` treated a string as valid when the pattern produced exactly one match anywhere in it. It now requires the pattern to match the entire string.

### Behavior change
- Because of the `RegexValidationRule` fix, unanchored patterns (including the built in email rule) now reject strings that only partially match. For example "hello a@b.io there" is no longer considered a valid email. Anchored patterns (such as the built in phone rule) are unaffected.

## [2.0.9]
- Previous release.
