//
//  XTIArray.swift
//  XTInputKit
//
//  Created by xt-input on 2019/8/24.
//

import Foundation

extension Array: XTIBaseNameNamespace {}

public extension XTITypeWrapperProtocol where WrappedType: Hashable {
    func toString() -> String {
        return "\(wrappedValue)"
    }
}
