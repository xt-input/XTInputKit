//
//  XTIDispatchQueue+.swift
//  XTInputKit
//
//  Created by xt-input on 2017/7/27.
//  Copyright © 2017年 PeopleHelp. All rights reserved.
//

import Foundation

extension DispatchQueue: XTIBaseNameNamespace {}

/// 用来保存onceSync的labelName
private var labelArray = [String]()

public extension XTITypeWrapperProtocol where WrappedType == DispatchQueue {
    /// 在主队列延时异步执行闭包
    /// - Parameters:
    ///   - qos: 优先级别
    ///   - time: 时间
    ///   - block: 闭包
    static func mainAsyncAfter(_ time: Float, block: @escaping () -> Void) {
        WrappedType.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(time * 1000)), execute: block)
    }

    /// 在非主队列延时异步执行闭包
    /// - Parameters:
    ///   - qos: 优先级别
    ///   - time: 时间
    ///   - block: 闭包
    static func globalAsyncAfter(_ qos: DispatchQoS.QoSClass = .default, time: Float, block: @escaping () -> Void) {
        WrappedType.global(qos: qos).asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(time * 1000)), execute: block)
    }

    /// 在应用生命周期里同步执行一次闭包
    /// - Parameters:
    ///   - label: 闭包的标记，一定要保证其唯一性
    ///   - block: 闭包
    static func onceSync(_ label: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if labelArray.contains(label) {
            return
        }
        block()
    }
}
