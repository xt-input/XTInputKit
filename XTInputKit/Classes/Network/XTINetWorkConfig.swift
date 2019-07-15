//
//  XTINetWorkConfig.swift
//  XTInputKit
//
//  Created by xt-input on 2018/3/16.
//  Copyright © 2018年 input. All rights reserved.
//
import Alamofire

public typealias XTIParameters = Parameters
public typealias XTIHTTPHeaders = HTTPHeaders

public extension XTIParameters {
    static func += (left: inout XTIParameters, right: XTIParameters) {
        right.forEach { key, value in
            left[key] = value
        }
    }
}

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

public enum XTIHttpScheme: String {
    case https = "https://"
    case http = "http://"
}

/// 网络请求相关的配置，例如：打印网络请求、host(eg: "design.tcoding.cn")、HttpScheme、网络超时时间、Content-Type、最大允许并发、公共参数(eg: bundelID、appVersion、systemVersion、UDID<伪造，真实UDID苹果不允许获取>，取idfv)
public struct XTINetWorkConfig {
    /// 是否打印网络请求原始数据
    #if DEBUG
        public static var iSLogRawData = true
    #else
        public static var iSLogRawData = false
    #endif

    public static var defaultHostName: String!
    public static var defaultHttpScheme = XTIHttpScheme.http
    public static var defaultContentType = "application/x-www-form-urlencoded; charset=utf-8"
    public static var defaultTimeoutInterval = 30.0
    public static var defaultHttpMaximumConnectionsPerHost = 10
    public static var defaultEncoding: ParameterEncoding = URLEncoding.default

    fileprivate static var _defaultopenHttpHeader: XTIHTTPHeaders!
    /// 公共参数，放置在请求头里
    public static var defaultopenHttpHeader: XTIHTTPHeaders {
        get {
            if _defaultopenHttpHeader == nil {
                _defaultopenHttpHeader = XTIHTTPHeaders()
            }
            let bundleInfo = Bundle.main.infoDictionary

            if _defaultopenHttpHeader["bundelID"] == nil {
                _defaultopenHttpHeader["bundelID"] = bundleInfo?["CFBundleIdentifier"] as? String
            }
            if _defaultopenHttpHeader["UUID"] == nil {
                _defaultopenHttpHeader["UUID"] = XTIKeyChainTool.shared().keyChainUuid
            }
            if _defaultopenHttpHeader["appVersion"] == nil {
                _defaultopenHttpHeader["appVersion"] = bundleInfo?["CFBundleShortVersionString"] as? String
            }
            if _defaultopenHttpHeader["systemVersion"] == nil {
                _defaultopenHttpHeader["systemVersion"] = UIDevice.current.systemVersion
            }
            _defaultopenHttpHeader["Content-Type"] = defaultContentType
            return _defaultopenHttpHeader
        } set {
            _defaultopenHttpHeader = newValue
        }
    }

    /// 网络请求签名，如果设置了该属性，所有的网络请求都会调用，如果某一个网络请求不需要可以继承XTIBaseRequest，然后重写signature方法
    public static var defaultSignature: ((_ parameters: XTIParameters) -> String)!
}
