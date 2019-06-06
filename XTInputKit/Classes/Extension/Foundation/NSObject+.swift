//
//  NSObject+.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2018/1/27.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

public extension NSObject {
    /// 取类名
    var className: String {
        return "\(self.classForCoder)"
    }

    static var className: String {
        return "\(self)"
    }
}
