//
//  XTITestResult.swift
//  XTInputKit
//
//  Created by Input on 2018/3/20.
//  Copyright © 2018年 input. All rights reserved.
//

import HandyJSON
import UIKit

/// 判断是否为空请使用isEmpty()
struct XTITestResult: HandyJSON {
    var result1: XTITestResult1!
    var result2: [XTITestResult1]!
}

struct XTITestResult1: HandyJSON {
    var int: Int!
    var float: Float!
    var string: String!
    var bool: Bool!
}
