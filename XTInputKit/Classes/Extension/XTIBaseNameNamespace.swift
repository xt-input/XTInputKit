//
//  XTIBaseNameNamespace.swift
//  XTInputKit
//
//  Created by xt-input on 2017/3/30.
//  Copyright © 2017年 tcoding.cn. All rights reserved.
//
import UIKit

public protocol XTIBaseNameNamespace {
    associatedtype WrapperType
    var xti: WrapperType { get }
    static var XTI: WrapperType.Type { get }
}

public extension XTIBaseNameNamespace {
    var xti: XTINamespaceWrapper<Self> {
        return XTINamespaceWrapper(value: self)
    }

    static var XTI: XTINamespaceWrapper<Self>.Type {
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
