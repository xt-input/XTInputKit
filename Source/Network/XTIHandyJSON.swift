//
//  XTIHandyJSON.swift
//  XTInputKit
//
//  Created by Input on 2018/3/20.
//  Copyright © 2018年 input. All rights reserved.
//

import HandyJSON

public extension HandyJSON {
    /// 判断对象是否为空，不能和nil做比较
    ///
    /// - Returns: 结果
    public func isEmpty() -> Bool {
        guard let string = self.toJSONString() else{
            return true
        }
        return ["", "{}", "[:]", "[]"].contains(string)
    }
}
