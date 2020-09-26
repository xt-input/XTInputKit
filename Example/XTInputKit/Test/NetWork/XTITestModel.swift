//
//  XTITestModel.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2019/7/7.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import UIKit

struct XTITestModel: XTIBaseModelProtocol, XTISharedProtocol {
//    init() {}

//    init?(map: Map) {}

    var name: String?
    var sex: String?

    var double: Double?
    var int: Int?
    var float: Float?

    var doubleStr: Double?
    var intStr: Int?
    var floatStr: Float?

    var stringNumber: String?

//    mutating func mapping(map: Map) {
//        double <- map["double"]
//        doubleStr <- map["doubleStr"]
//        float <- map["float"]
//        floatStr <- map["floatStr"]
//        int <- map["int"]
//        intStr <- map["intStr"]
//        name <- map["name"]
//        sex <- map["sex"]
//        stringNumber <- map["stringNumber"]
//    }
}

