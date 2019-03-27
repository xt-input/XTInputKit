//
//  XTITest1Request.swift
//  XTInputKit
//    该类管理域名为 design1.07coding.com 的接口
//  Created by Input on 2018/3/20.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit
import XTInputKit

class XTITest1Request: XTIBaseRequest {
    static var sharedInstance = XTITest1Request()

    override init() {
        super.init()
        self.hostName = "design1.tcoding.cn"
    }
}
