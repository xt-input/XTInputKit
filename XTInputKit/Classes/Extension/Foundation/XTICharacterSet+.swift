//
//  XTICharacterSet+.swift
//  XTInputKit
//
//  Created by xt-input on 2019/7/2.
//

import Foundation

extension CharacterSet: XTIBaseNameNamespace {}

public extension XTITypeWrapperProtocol where WrappedType == CharacterSet {
    /// url参数的编码字符集
    static var urlParameterAllowed: CharacterSet {
        return CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]"))
    }
}
