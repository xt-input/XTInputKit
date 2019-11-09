//
//  XTISharedProtocol.swift
//  XTInputKit
//
//  Created by xt-input on 2019/7/8.
//

import Foundation
private var xtiSharedDict = [String: Any]()

public protocol XTISharedProtocol {
    init()
    static func shared() -> Self
    static func deShared()
}

extension XTISharedProtocol {
    public static func shared() -> Self {
        var shared = xtiSharedDict["\(Self.self)"] as? Self
        if shared == nil {
            shared = Self()
            xtiSharedDict["\(Self.self)"] = shared
        }
        return shared!
    }

    public static func deShared() {
        xtiSharedDict.removeValue(forKey: "\(Self.self)")
    }
}
