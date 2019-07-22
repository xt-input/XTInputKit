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

    public static var defaultHostName: String?
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
    public static var defaultSignature: ((_ parameters: XTIParameters) -> String)?

    /// 加解密闭包
    public static var defaultEncrypt: ((_ parameters: XTIParameters) -> XTIParameters)?
    public static var defaultDecrypt: ((_ value: String) -> String)?

    /// 结果回调过滤操作
    public static var defaultFilterRequest: ((_ value: inout Any?, _ error: inout Error?) -> Void)?
}
