//
//  XTITest1Request.swift
//  XTInputKit
//    该类管理域名为 design1.07coding.com 的接口
//  Created by xt-input on 2018/3/20.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit
import XTInputKit

class XTITest1Request: XTIBaseRequest {
    static let shared = XTITest1Request()
    static func awake(){
    
    }
    override init() {
        super.init()
        self.hostName = "design.tcoding.cn"
    }
}
