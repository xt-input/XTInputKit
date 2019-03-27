//
//  学生.swift
//  XTInputKit_Example
//
//  Created by xt-input on 2019/3/27.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import Foundation

class 学生 {
    var 身高 = 160
    var 体重 = 50.0
    var 姓名 = "大黄"
}

class 学生成绩: 学生 {
    var 语文 = 60
    var 数学 = 60
    var 英语 = 0
    func 总成绩() -> Int {
        return 语文 + 数学 + 英语
    }
}
