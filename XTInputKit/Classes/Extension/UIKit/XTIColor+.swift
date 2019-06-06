//
//  XTIColor+.swift
//  XTInputKit
//
//  Created by xt-input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//

import UIKit

extension UIColor: XTIBaseNameNamespace {}

public extension XTITypeWrapperProtocol where WrappedType == UIColor {
    /// 通过16进制的整数获取颜色
    ///
    /// - Parameter hex: 颜色的16进制数值
    /// - Returns: 得到的颜色
    static func hex(_ hex: UInt32) -> UIColor {
        return WrappedType.XTI.hex(hex, alpha: 1)
    }

    /// 通过16进制的整数及透明度获取颜色
    ///
    /// - Parameters:
    ///   - hex: 颜色的16进制数值
    ///   - alpha: 透明度
    /// - Returns: 得到的颜色
    static func hex(_ hex: UInt32, alpha: CGFloat) -> UIColor {
        let red = CGFloat((hex >> 16) % 256) / 255.0
        let green = CGFloat((hex >> 8) % 256) / 255.0
        let blue = CGFloat(hex % 256) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    /// 获取随机的颜色
    static var random: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }
}
