# XTINetwork

​	`XTINetwork`提供两个类和一个协议：`XTINetWorkConfig`、`XTIBaseRequest`和`XTIBaseModelProtocol`。`XTINetWorkConfig`用来管理网络请求的域名、方法、URLSessionConfiguration的配置、请求的公共头、接口签名；`XTIBaseReques`t用于发起网络请求；`XTIBaseModelProtocol`为数据模型的基本协议，定义数据模型的时候请实现该协议。

​	XTIBaseRequest提供了一个单例对象，如果域名参数等使用XTINetWorkConfig里的配置，可以直接用XTIBaseRequest单例发起网络请求，也可以继承XTIBaseRequest，为每个网络请求创建一个类来管理；如果需要管理多个域名的网络请求可以为每个域名建一个类，在类的init函数里设置相关参数。

> 文档更新会比较慢，最新修改请查看源码

## 参数说明

### XTINetWorkConfig

```swift
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

public extension Dictionary where Key == String, Value == Any {

    public static func += (left: inout XTIParameters, right: XTIParameters)
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
    public var realValue: String { get }

    /// return "\(Self.self)/\(self.realValue)"       eg:  User.login.originalValue ==> "User/login"
    public var originalValue: String { get }

    /// return "\(Self.self)/\(self)"的小写        eg:  User.login.value ==> "user/login"
    public var value: String { get }

    /// 三段式服务器架构指定控制器，例如ThinkPHP，
    public static var app: String { get }

    /// 如果接口模块名字和成员名字不一致需要实现它
    public static var realValue: String { get }

    /// return "\(Self.self)"       eg:  User.originalValue ==> "User"
    public static var originalValue: String { get }

    /// return "\(Self.self)"的小写        eg: User.value ==> "User"
    public static var value: String { get }
}

public enum XTIHttpScheme : String {

    case https

    case http
}

/// 网络请求相关的配置，例如：打印网络请求、host(eg: "design.tcoding.cn")、HttpScheme、网络超时时间、Content-Type、最大允许并发、公共参数(eg: bundelID、appVersion、systemVersion、UDID<伪造，真实UDID苹果不允许获取>，取idfv)
public struct XTINetWorkConfig {

    public static var iSLogRawData: Bool

    public static var defaultHostName: String!

    public static var defaultHttpScheme: XTInputKit.XTIHttpScheme

    public static var defaultContentType: String

    public static var defaultTimeoutInterval: Double

    public static var defaultHttpMaximumConnectionsPerHost: Int

    public static var defaultEncoding: ParameterEncoding

    /// 公共参数，放置在请求头里
    public static var defaultopenHttpHeader: XTIHTTPHeaders { get set }

    /// 网络请求签名，如果设置了该属性，所有的网络请求都会调用，如果某一个网络请求不需要可以继承XTIBaseRequest，然后重写signature方法
    public static var defaultSignature: ((_ parameters: XTIParameters) -> String)!
}

```

### XTIBaseRequest

```swift
//
//  XTIBaseRequest.swift
//  XTInputKit
//
//  Created by xt-input on 2018/3/16.
//  Copyright © 2018年 input. All rights reserved.
//

import Alamofire
/// 网络请求成功的回调
public typealias XTIRequestSuccessCallback = (Any?) -> Void
/// 网络请求失败的回调
public typealias XTIRequestErrorCallback = (Error?) -> Void
/// 网络请求完成的回调
public typealias XTIRequestCompleteCallback = (Any?, Error?) -> Void
/// 文件上传下载进度的回调
public typealias XTIProgressCallback = (Progress) -> Void

open class XTIBaseRequest : RequestInterceptor, XTISharedProtocol {

    /// 是否打印接口响应的原始数据
    public var iSLogRawData: Bool?

    /// 是否需要签名
    public var isNeedSign: Bool

    /// HttpMethod，仅支持post or get，默认post
    public var httpMethod: HTTPMethod?

    public var encoding: ParameterEncoding?

    /// http or https
    public var httpScheme: XTIHttpScheme?

    /// 服务器域名，包括端口号，80、443可以忽略
    public var hostName: String?

    /// 具体服务，域名后面的那一串
    public var serviceName: String?

    public var resultType: XTIBaseModelProtocol.Type?

    public var result: DataResponse<String>!

    public static var isUserSharedSession: Bool

    public var isUserSharedSession: Bool! { get set }

    public var fileType: String?

    public required init()

    /// 构造请求参数，如果是POST则放在body里面，如果是GET则拼接在URL后面
    ///
    /// - Returns: 参数字典
    open func buildParameters() -> XTIParameters

    /// 上传文件请求时重写它，
    /// 有 application/atom+xml, application/ecmascript, application/EDI-X12, application/EDIFACT, application/json, application/javascript, application/octet-stream, application/ogg, application/pdf, application/postscript, application/rdf+xml, application/rss+xml, application/soap+xml, application/font-woff, application/xhtml+xml, application/xml, application/xml-dtd, application/xop+xml, application/zip, application/gzip, audio/mp4, audio/mpeg, audio/ogg, audio/vorbis, audio/vnd.rn-realaudio, audio/vnd.wave, audio/webm, audio/x-flac, image/gif, image/jpeg, image/png, image/webp, image/svg+xml, image/tiff, model/example, model/iges, model/mesh, model/vrml, model/x3d+binary, model/x3d+vrml, model/x3d+xml, text/css, text/csv, text/html, text/plain, text/vcard, text/xml, video/mpeg, video/mp4, video/ogg, video/quicktime, video/webm, video/x-matroska, video/x-ms-wmv, video/x-flv ···等类型
    /// - Returns: 返回文件类型
    open func getFileType() -> String

    /// 签名，如果继承，可以为每个请求实现不同的签名方式
    ///     该函数根据自己的需求实现，建议将参数字典转换成json字符串然后取这段字符串的签名
    /// 公共参数放置在请求头里面
    /// - Returns: 返回签名，格式："sign=sign"
    open func signature(_ parameters: XTIParameters?) -> String
}

extension XTIBaseRequest {

    /// post网络请求，域名等信息使用XTINetWorkConfig的配置，只需要传入服务名和参数及回调的闭包，适用于一个方法管理一个网络请求
    ///
    /// - Parameters:
    ///   - serviceName: 服务名
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - errorCallback: 失败的回调
    ///   - successCallBack: 成功的回调XTIBaseModelProtocol>
    ///   - completedCallback: 请求完成的回调
    open func post(serviceName: String, parameters: XTIParameters? = nil, resultType: XTIBaseModelProtocol.Type? = nil, success successCallBack: XTIRequestSuccessCallback? = nil, error errorCallback: XTIRequestErrorCallback? = nil, completed completedCallback: XTIRequestCompleteCallback? = nil)

    /// post网络请求，不使用XTINetWorkConfig的域名信息，适用于多台服务器网络请求
    ///
    /// - Parameters:
    ///   - url: 网络请求的地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - successCallBack: 成功的回调
    ///   - completedCallback: 请求完成的回调
    ///   - errorCallback: 失败的回调
    open func post(url: String, parameters: XTIParameters? = nil, resultType: XTIBaseModelProtocol.Type? = nil, success successCallBack: XTIRequestSuccessCallback? = nil, error errorCallback: XTIRequestErrorCallback? = nil, completed completedCallback: XTIRequestCompleteCallback? = nil)
}

extension XTIBaseRequest {

    /// get网络请求，域名等信息使用XTINetWorkConfig的配置，只需要传入服务名和参数及回调的闭包，适用于一个方法管理一个网络请求
    ///
    /// - Parameters:
    ///   - serviceName: 服务名
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - errorCallback: 失败的回调
    ///   - successCallBack: 成功的回调
    ///   - completedCallback: 请求完成的回调
    open func get(serviceName: String? = nil, parameters: XTIParameters? = nil, resultType: XTIBaseModelProtocol.Type? = nil, success successCallBack: XTIRequestSuccessCallback? = nil, error errorCallback: XTIRequestErrorCallback? = nil, completed completedCallback: XTIRequestCompleteCallback? = nil)

    /// get网络请求，不使用XTINetWorkConfig的域名信息，适用于多台服务器网络请求
    ///
    /// - Parameters:
    ///   - url: 网络请求的地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - errorCallback: 失败的回调
    ///   - completedCallback: 请求完成的回调
    open func get(url: String, parameters: XTIParameters? = nil, resultType: XTIBaseModelProtocol.Type? = nil, success successCallBack: XTIRequestSuccessCallback? = nil, error errorCallback: XTIRequestErrorCallback? = nil, completed completedCallback: XTIRequestCompleteCallback? = nil)
}

extension XTIBaseRequest {

    /// 汇总的网络请求，除了回调都有默认参数，默认参数取XTINetWorkConfig里的配置，默认参数可以在初始化对象的时候设置，如果一个类管理一个接口可以在子类里设置所有的默认参数
    ///
    /// - Parameters:
    ///   - method: HttpMethod，仅支持post or get
    ///   - scheme: HttpScheme, http or https
    ///   - host: 域名    非约定端口的请求请带上端口号
    ///   - service: 服务名
    ///   - parameters: 参数，可以传递进去，如果使用一个类管理一个接口请在buildParameters方法里构造参数
    ///   - result: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - errorCallback: 失败的回调
    ///   - successCallBack: 成功的回调
    ///   - completedCallback: 请求完成的回调
    open func send(_ method: HTTPMethod? = nil, httpScheme scheme: XTIHttpScheme? = nil, hostName host: String? = nil, serviceName service: String? = nil, parameters: XTIParameters? = nil, resultType: XTIBaseModelProtocol.Type? = nil, success successCallBack: XTIRequestSuccessCallback? = nil, error errorCallback: XTIRequestErrorCallback? = nil, completed completedCallback: XTIRequestCompleteCallback? = nil)

    /// 汇总的网络请求，默认参数取XTINetWorkConfig里的配置
    ///
    /// - Parameters:
    ///   - method: HttpMethod，仅支持post or get
    ///   - url: 网络地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - errorCallback: 失败的回调
    ///   - successCallBack: 成功的回调
    ///   - completedCallback: 请求完成的回调
    public func send(_ method: HTTPMethod? = nil, url: String? = nil, parameters: XTIParameters? = nil, resultType: XTIBaseModelProtocol.Type? = nil, success successCallBack: XTIRequestSuccessCallback? = nil, error errorCallback: XTIRequestErrorCallback? = nil, completed completedCallback: XTIRequestCompleteCallback? = nil)
}

extension XTIBaseRequest {

    /// 文件上传，适用于一个类管理一个接口，可以在子类里设置所有的默认参数
    ///
    /// - Parameters:
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - progressCallback: 进度
    ///   - errorCallback: 失败的回调
    ///   - successCallBack: 成功的回调
    ///   - completedCallback: 请求完成的回调
    open func upload(_ resultType: XTIBaseModelProtocol.Type, progressCallback: XTIProgressCallback? = nil, successCallBack: XTIRequestSuccessCallback? = nil, errorCallback: XTIRequestErrorCallback? = nil, completed completedCallback: XTIRequestCompleteCallback? = nil)

    /// 文件上传，适用于用单例一个方法管理一个请求
    ///     文件上传时请将文件转成Data放置在parameters里
    /// - Parameters:
    ///   - url: 上传的地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - progressCallback: 进度
    ///   - errorCallback: 失败的回调
    ///   - successCallBack: 成功的回调
    ///   - completedCallback: 请求完成的回调
    open func upload(_ url: String, parameters: XTIParameters?, resultType: XTIBaseModelProtocol.Type? = nil, progress progressCallback: XTIProgressCallback? = nil, success successCallBack: XTIRequestSuccessCallback? = nil, error errorCallback: XTIRequestErrorCallback? = nil, completed completedCallback: XTIRequestCompleteCallback? = nil)
}


extension XTIBaseRequest {

    /// 文件下载(该方法仅适用于单个文件，如果文件很多推荐使用TYDownloadManager) <比较鸡肋>
    ///
    /// - Parameters:
    ///   - url: 文件地址
    ///   - filePath: 文件存放路径，如果为空则放置在/Library/Caches
    ///   - progressCallback: 下载进度回调
    ///   - errorCallback: 失败的回调
    ///   - successCallBack: 下载成功的回调
    ///   - errorCallback: 下载失败的回调
    public static func download(_ url: String, filePath: URL? = nil, progressCallback: XTIProgressCallback? = nil, successCallBack: XTIRequestSuccessCallback? = nil, error errorCallback: XTIRequestErrorCallback? = nil, completed completedCallback: XTIRequestCompleteCallback? = nil)
}

extension XTIBaseRequest {

    /// 打印原始数据，可以在该函数里面读取Cookie的值
    ///
    /// - Parameter result: 原始数据
    open func outRawData(_ result: DataResponse<String>)
}

```

> 具体的实现及DEMO请访问[XTInputKit](https://github.com/xt-input/XTInputKit)

