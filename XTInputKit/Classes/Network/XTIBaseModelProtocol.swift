//
//  XTIBaseModelProtocol.swift
//  XTInputKit
//
//  Created by xt-input on 2019/7/8.
//

import Foundation
import XTIObjectMapper

public protocol XTIBaseModelProtocol: Mappable {
    mutating func didHandleResult()
    mutating func isEmpty() -> Bool
}

extension XTIBaseModelProtocol {
    static func handleResult(_ value: String) -> Self? {
        var result = Mapper<Self>().map(JSONString: value)
        result?.didHandleResult()
        return result
    }

    public mutating func didHandleResult() {}

    public mutating func isEmpty() -> Bool {
        return ["{}", "[]", "", "[:]", "{:}", "nil", "null"].contains(self.toJSONString() ?? "nil")
    }
}