//
//  XTITest1Request.swift
//  XTInputKit
//    该类管理域名为 design1.07coding.com 的接口
//  Created by xt-input on 2018/3/20.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

class XTITest1Request: XTIBaseRequest {
    override func buildParameters() -> XTIParameters {
        var parameters = super.buildParameters()
        parameters["bundelID"] = 123123123
        return parameters
    }

    required init() {
        super.init()
        hostName = "design.tcoding.cn"
    }

    
}
