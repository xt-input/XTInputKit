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
    /// 通过16进制的字符串获取颜色，支持0x、#或不带前缀
    /// - Parameter hex: 颜色的16进制字符串，可以包括透明通道
    static func hex(_ hex: String) -> UIColor {
        var tempHex = hex.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "0x", with: "")
        #if DEBUG
            if tempHex.count != 6 && tempHex.count != 8 {
                print("16进制字符串格式不对")
            }
        #endif
        var hexInt: UInt64 = 0
        var aHexInt: UInt64 = 255
        Scanner(string: String(tempHex.prefix(6))).scanHexInt64(&hexInt)
        if tempHex.count == 8 {
            Scanner(string: String(tempHex.suffix(2))).scanHexInt64(&aHexInt)
        }

        return WrappedType.xti.hex(hexInt, alpha: CGFloat(aHexInt) / 255.0)
    }

    /// 通过16进制的整数获取颜色，不包含透明通道
    /// - Parameter hex: 颜色的16进制数值，不包括透明通道
    /// - Returns: 得到的颜色
    static func hex(_ hex: UInt64) -> UIColor {
        return WrappedType.xti.hex(hex, alpha: 1)
    }

    /// 通过16进制的整数及透明度获取颜色
    /// - Parameters:
    ///   - hex: 颜色的16进制数值，不包括透明通道
    ///   - alpha: 透明度
    /// - Returns: 得到的颜色
    static func hex(_ hex: UInt64, alpha: CGFloat) -> UIColor {
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
