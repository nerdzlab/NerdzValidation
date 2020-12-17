# NerdzValidation
> Package to easy validate text just by passing validation rules!

## Code Examples
To validate email text field, that is required and should be have at least 4 and at most 200 characters:
`let validationResult = "someEmail@gmail.com.validate(with: [
                                NotEmptyRule(errorMessage: errorMessage),
                                ShouldBeInRangeRule(
                                    lowerBoundErrorMessage: errorMessage,
                                    upperBoundErrorMessage: errorMessage,
                                    lowerBound: 4,
                                    upperBound: 200
                                ),
                                RegexValidationRule(regexPattern: regexString, errorMessage: errorMessage)
        ])`

