//
//  XTINetWorkConfig.swift
//  XTInputKit
//
//  Created by Input on 2018/3/16.
//  Copyright © 2018年 input. All rights reserved.
//
import Alamofire
import HandyJSON

public typealias XTIParameters = Parameters
public typealias XTIHTTPHeaders = HTTPHeaders

public enum XTIHttpScheme: String {
    case https = "https://"
    case http = "http://"
}

/// 网络请求相关的配置，例如：打印网络请求、host(eg: "design.07coding.com")、HttpScheme、网络超时时间、Content-Type、最大允许并发、公共参数(eg: bundelID、appVersion、systemVersion、UDID<伪造，真实UDID苹果不允许获取>，取idfv)
public struct XTINetWorkConfig {
    /// 是否打印网络请求原始数据
    public static var iSLogRawData = true
    public static var defaultHostName: String!
    public static var defaultHttpScheme = XTIHttpScheme.http
    public static var defaultContentType = "multipart/form-data; charset=utf-8"
    public static var defaultTimeoutInterval = 30.0
    public static var defaultHttpMaximumConnectionsPerHost = 10

    fileprivate static var _defaultopenHttpHeader: XTIHTTPHeaders!
    /// 公共参数，放置在请求头里
    public static var defaultopenHttpHeader: XTIHTTPHeaders! {
        get {
            if _defaultopenHttpHeader == nil {
                _defaultopenHttpHeader = XTIHTTPHeaders()
            }
            let bundleInfo = Bundle.main.infoDictionary

            if _defaultopenHttpHeader["bundelID"] == nil {
                _defaultopenHttpHeader["bundelID"] = bundleInfo?["CFBundleIdentifier"] as? String
            }
            if _defaultopenHttpHeader["UUID"] == nil {
                _defaultopenHttpHeader["UUID"] = XTIKeyChainTool.default.keyChainUuid
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
//    public static var defaultSignature: ((_ parameters: XTIParameters) -> String)!
}
