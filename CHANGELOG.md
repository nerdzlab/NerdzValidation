# Changelog

All notable changes to NerdzValidation are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0]

### Added
- Rewritten README that documents the real `.nzv` API with working installation, quick start, rule table, and usage examples.
- Swift Testing target (`NerdzValidationTests`) covering every rule, the rules container, the result type, and the `.nzv` String extension (around 99% line coverage).
- DocC documentation catalog with a landing page, a Getting Started article, and reference docs on all public symbols.

### Changed
- `Package.swift` `swift-tools-version` raised from 5.3 to 5.9 to support Swift Testing. The runtime deployment target is unchanged (tests are not shipped).

### Fixed
- `IsPhoneValidationRule` returned "Invalid email address" as its default failure message. It now returns "Invalid phone number".
- `CombinedValidationRule` evaluated each rule twice when a container level message was set. Rules are now evaluated exactly once. Output is unchanged.
- `RegexValidationRule` treated a string as valid when the pattern produced exactly one match anywhere in it. It now requires the pattern to match the entire string.

### Behavior change
- Because of the `RegexValidationRule` fix, unanchored patterns (including the built in email rule) now reject strings that only partially match. For example "hello a@b.io there" is no longer considered a valid email. Anchored patterns (such as the built in phone rule) are unaffected.

## [2.0.9]
- Previous release.
