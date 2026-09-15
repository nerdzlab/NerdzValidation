# Validation in MVVM

Keep every validation rule in one place and drive your SwiftUI forms from it.

## Overview

The value of NerdzValidation grows when you stop scattering validation across views. Instead of
sprinkling `if text.isEmpty` checks through the UI, you describe each field as an ordered list
of rules in a single type, hand those rules to a view model, and let the view render whatever
``ValidationResult`` comes back. The rules become the single source of truth: consistent
messages, one place to change them, and logic you can unit test without a UI.

This article shows the pattern in three layers: a rules provider, a view model, and a view.

## 1. Centralize the rules

Put the rules for every field behind one type. A protocol keeps it injectable and testable, and
the implementation is the only place validation logic lives.

```swift
import NerdzValidation

protocol FormValidationUseCaseProtocol {
    func makeEmailRules() -> [ValidationRule]
    func makePasswordRules() -> [ValidationRule]
}

struct FormValidationUseCase: FormValidationUseCaseProtocol {
    func makeEmailRules() -> [ValidationRule] {
        [
            NotEmptyValidationRule(message: "Email is required"),
            IsEmailValidationRule(message: "Enter a valid email address")
        ]
    }

    func makePasswordRules() -> [ValidationRule] {
        [
            NotEmptyValidationRule(message: "Password is required"),
            LengthRangeValidationRule(lowerBound: 8, lowerBoundMessage: "Use at least 8 characters")
        ]
    }
}
```

Because rules are just values, a shared package can vend them once and every platform target
(iOS, macOS, and so on) reuses the exact same logic and copy.

## 2. Validate in the view model

The view model injects the rules provider and exposes a ``ValidationResult`` per field. It calls
the array based ``NZValidationExtensionData/validate(with:shouldCombineErrorMessages:message:)``
overload, so it never has to know which rules are involved.

```swift
import NerdzValidation

@MainActor
protocol SignUpViewModelType {
    var email: String { get set }
    var password: String { get set }
    var emailValidation: ValidationResult { get }
    var passwordValidation: ValidationResult { get }
    var isFormValid: Bool { get }

    func validate()
}

@Observable
@MainActor
final class SignUpViewModel: SignUpViewModelType {
    var email = ""
    var password = ""

    private(set) var emailValidation: ValidationResult = .valid
    private(set) var passwordValidation: ValidationResult = .valid

    var isFormValid: Bool {
        emailValidation.isValid && passwordValidation.isValid
    }

    private let validationUseCase: FormValidationUseCaseProtocol

    init(validationUseCase: FormValidationUseCaseProtocol = FormValidationUseCase()) {
        self.validationUseCase = validationUseCase
    }

    func validate() {
        emailValidation = email.nzv.validate(with: validationUseCase.makeEmailRules())
        passwordValidation = password.nzv.validate(with: validationUseCase.makePasswordRules())
    }
}
```

``ValidationRule`` conforms to `Sendable` and ``ValidationResult`` is `Sendable` and `Equatable`,
so the rules and results sit comfortably inside a `@MainActor` `@Observable` view model and play
well with Swift 6 strict concurrency.

## 3. Bind it in the view

The view stays dumb: it shows `result.message` when there is one and enables the button from
`isFormValid`. It never contains a validation rule.

```swift
import SwiftUI

struct SignUpView<ViewModel: SignUpViewModelType>: View {
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        VStack(alignment: .leading, spacing: 16) {
            field(title: "Email", text: $viewModel.email, error: viewModel.emailValidation.message)
            field(title: "Password", text: $viewModel.password, error: viewModel.passwordValidation.message)

            Button("Sign up") {
                viewModel.validate()
            }
            .disabled(!viewModel.isFormValid)
        }
        .onChange(of: viewModel.email) { viewModel.validate() }
        .onChange(of: viewModel.password) { viewModel.validate() }
    }

    private func field(title: String, text: Binding<String>, error: String?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(title, text: text)

            if let error {
                Text(error).foregroundStyle(.red)
            }
        }
    }
}
```

## Bridging to a design system input state

If your design system has an input component with its own state, map ``ValidationResult`` to it
in one initializer and reuse it everywhere.

```swift
extension AppInputView.ViewState {
    init(_ result: ValidationResult) {
        self = result.isValid ? .normal : .error(result.message ?? "")
    }
}
```

## Why this structure

- One source of truth. Every rule and message for a field lives in one method, not scattered
  across views.
- Consistency. The same rules produce the same messages on every screen and platform.
- Testable. The rules provider and the view model are plain types you can unit test without a UI.
- Composable. Swap `shouldCombineErrorMessages` to show one error or all of them, and reuse
  ``OrValidationRule`` or ``NotValidationRule`` without touching the view.
