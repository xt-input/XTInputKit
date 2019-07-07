//
//  XTISharedProtocol.swift
//  XTInputKit
//
//  Created by xt-input on 2019/7/8.
//

import Foundation
var SharedDict = [String: Any]()

public protocol XTISharedProtocol {
    init()
    static func shared() -> Self
}

extension XTISharedProtocol {
    public static func shared() -> Self {
        var shared = SharedDict["\(Self.self)"] as? Self
        if shared == nil {
            shared = Self.init()
            SharedDict["\(Self.self)"] = shared
        }
        return shared!
    }
}
