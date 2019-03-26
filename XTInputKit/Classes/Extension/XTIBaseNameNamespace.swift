//
//  XTIBaseNameNamespace.swift
//  XTInputKit
//
//  Created by Input on 2017/3/30.
//  Copyright © 2017年 xt-hacker.com. All rights reserved.
//
import UIKit

public protocol XTIBaseNameNamespace {
    associatedtype WrapperType
    var xti: WrapperType { get }
    static var XTI: WrapperType.Type { get }
}

public extension XTIBaseNameNamespace {
    public var xti: XTINamespaceWrapper<Self> {
        return XTINamespaceWrapper(value: self)
    }

    public static var XTI: XTINamespaceWrapper<Self>.Type {
        return XTINamespaceWrapper.self
    }
}

public protocol XTITypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct XTINamespaceWrapper<T>: XTITypeWrapperProtocol {
    public var wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
