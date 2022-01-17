//
//  NZValidationExtensionData.swift.swift
//  
//
//  Created by Roman Kovalchuk on 14.01.2022.
//

import Foundation

public class NZValidationExtensionData<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

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

