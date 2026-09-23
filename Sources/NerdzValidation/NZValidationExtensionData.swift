//
//  NZValidationExtensionData.swift.swift
//  
//
//  Created by Roman Kovalchuk on 14.01.2022.
//

import Foundation

/// A namespace wrapper that hosts the NerdzValidation API under the `.nzv` property.
///
/// You rarely construct this directly. Reach the validation methods through
/// `"someString".nzv`.
public class NZValidationExtensionData<Base> {

    /// The wrapped value the validation methods operate on.
    public let base: Base

    /// Wraps a value in the validation namespace.
    /// - Parameter base: The value to wrap.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that exposes the NerdzValidation API through the `.nzv` namespace.
public protocol NZValidationExtensionCompatible {
    /// Extended type
    associatedtype NZExtensionBase

    /// NZ extensions.
    static var nzv: NZValidationExtensionData<NZExtensionBase>.Type { get }

    /// NZ extensions.
    var nzv: NZValidationExtensionData<NZExtensionBase> { get }
}

extension NZValidationExtensionCompatible {
    
    /// NZ extensions.
    public static var nzv: NZValidationExtensionData<Self>.Type {
        get { NZValidationExtensionData<Self>.self }
    }

    /// Reactive extensions.
    public var nzv: NZValidationExtensionData<Self> {
        get { NZValidationExtensionData(self) }
    }
}

