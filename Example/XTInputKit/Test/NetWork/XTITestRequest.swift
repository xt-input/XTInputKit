//
//  XTITestRequest.swift
//  XTInputKit
//	在发送网络请求之前设置XTINetWorkConfig的相关属性，所有的网络请求都是同一台服务器。该类管理/rxswift/login/index接口，
//  Created by xt-input on 2018/3/20.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

class XTITestRequest: XTIBaseRequest {
    var bundelID: String!

    required init() {
        super.init()
        serviceName = "/rxswift/login/index"
        httpMethod = .post
    }

    override func buildParameters() -> XTIParameters {
        var parameters = super.buildParameters()
        parameters["bundelId"] = bundelID
        return parameters
    }

    deinit {
        xtiloger.debug(self)
    }
}
