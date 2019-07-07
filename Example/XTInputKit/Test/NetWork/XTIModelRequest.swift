//
//  XTIModelRequest.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2019/7/7.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import UIKit

class XTIModelRequest: XTIBaseRequest {
    var name = "123"
    var sex = "man"

    override func buildParameters() -> XTIParameters {
        var parameters = super.buildParameters()
        parameters["name"] = name
        parameters["sex"] = sex
        return parameters
    }

    required init() {
        super.init()
        serviceName = "/rxswift/login/getUserInfo"
        resultType = XTITestModel.self
    }
}
