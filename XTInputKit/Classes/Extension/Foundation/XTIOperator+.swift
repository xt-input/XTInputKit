//
//  XTIOperator+.swift
//  XTInputKit
//
//  Created by Input on 2018/5/2.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

public extension Double {
    public static func += (left: inout Double, right: Int) {
        left = left + Double(right)
    }

    public static func += (left: inout Double, right: Int8) {
        left = left + Double(right)
    }

    public static func += (left: inout Double, right: Int32) {
        left = left + Double(right)
    }

    public static func += (left: inout Double, right: Int64) {
        left = left + Double(right)
    }

    public static func -= (left: inout Double, right: Int) {
        left = left - Double(right)
    }

    public static func -= (left: inout Double, right: Int8) {
        left = left - Double(right)
    }

    public static func -= (left: inout Double, right: Int32) {
        left = left - Double(right)
    }

    public static func -= (left: inout Double, right: Int64) {
        left = left - Double(right)
    }
}

public extension Int {
    public static postfix func ++ (left: inout Int) {
        left = left + 1
    }
}
