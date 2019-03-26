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
    var code: String?
    var message: String?
    var result: Result?
}

struct Result: HandyJSON {
    var currentPage: Int?
    var pageSize: Int?
    var resultList: [ResultList]?
    var totalCount: Int?
    var totalPage: Int?
}

struct ResultList: HandyJSON {
    var multimediaId: Int?
    var multimediaPath: String?
    var multimediaTitle: String?
    var picturePath: String?
    var screenshotPath: String?
    var subscribeId: Int?
}
