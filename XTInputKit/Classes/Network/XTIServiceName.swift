//
//  XTIServiceName.swift
//  XTInputKit
//
//  Created by xt-input on 2019/7/18.
//

import Foundation

/// 接口名字管理协议，两段式：Module/action，三段式：App/Module/action。默认使用两段式，如果需要使用三段式请设置`app`属性
public protocol XTIServiceName {
    var realValue: String { get }
    var originalValue: String { get }
    var value: String { get }

    /// 三段式服务器架构指定控制器，例如ThinkPHP
    static var app: String { get }
    static var realValue: String { get }
    static var originalValue: String { get }
    static var value: String { get }
}

public extension XTIServiceName {
    /// 如果接口方法名字和成员名字不一致需要实现它
    var realValue: String {
        return "\(self)"
    }

    /// return "\(Self.self)/\(self.realValue)"       eg:  User.login.originalValue ==> "User/login"
    var originalValue: String {
        return "\(Self.originalValue)/\(self.realValue)"
    }

    /// return "\(Self.self)/\(self)"的小写        eg:  User.login.value ==> "user/login"
    var value: String {
        return self.originalValue.lowercased()
    }

    /// 三段式服务器架构指定控制器，例如ThinkPHP，
    static var app: String {
        return ""
    }

    /// 如果接口模块名字和成员名字不一致需要实现它
    static var realValue: String {
        return "\(self)"
    }

    /// return "\(Self.self)"       eg:  User.originalValue ==> "User"
    static var originalValue: String {
        return (self.app.count > 0 ? "\(self.app)/" : "") + "\(self.realValue)"
    }

    /// return "\(Self.self)"的小写        eg: User.value ==> "User"
    static var value: String {
        return Self.originalValue.lowercased()
    }
}
