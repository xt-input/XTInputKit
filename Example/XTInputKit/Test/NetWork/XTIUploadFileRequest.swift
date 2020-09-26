//
//  XTIUploadFileRequest.swift
//  Demo
//
//  Created by xt-input on 2019/11/12.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import UIKit

class XTIUploadFileRequest: XTIBaseRequest {
    override func getFileType() -> String {
        return "image/png"
    }

    override func buildParameters() -> XTIParameters {
        var parameters = super.buildParameters()
        if let data = UIImage(named: "1234567")?.pngData() {
            parameters["file"] = data
        }

        return parameters
    }

    required init() {
        super.init()
        serviceName = "/rxswift/login/uploadfile"
    }
}
