# XTINetwork

​	XTINetwork是一个用于Swift语言的网络抽象层，依赖于[Alamofire](https://github.com/Alamofire/Alamofire)及[HandyJSON](https://github.com/alibaba/HandyJSON)。是XTInputKit/Swift的一部分。

<!--more-->

​	XTINetwork提供两个类：XTINetWorkConfig和XTIBaseRequest。XTINetWorkConfig用来管理网络请求的域名、方法、URLSessionConfiguration的配置、请求的公共头、接口签名，XTIBaseRequest用了发起网络请求。

​	XTIBaseRequest提供了一个单例对象，如果域名参数等使用XTINetWorkConfig里的配置，可以直接用XTIBaseRequest单例发起网络请求，也可以继承XTIBaseRequest，为每个网络请求创建一个类来管理；如果需要管理多个域名的网络请求可以为每个域名建一个类，在类的init函数里设置相关参数。

## 参数说明

### XTINetWorkConfig

```swift
// 接口是否打印
public static var iSLogRawData = true
public static var defaultHostName: String!
public static var defaultHttpScheme = XTIHttpScheme.http
//MARK: - 
public static var defaultContentType = "multipart/form-data; charset=utf-8"
public static var defaultTimeoutInterval = 30.0
public static var defaultHttpMaximumConnectionsPerHost = 10

fileprivate static var _defaultPublicHttpHeader: XTIHTTPHeaders!
/// 公共参数，放置在请求头里
public static var defaultPublicHttpHeader: XTIHTTPHeaders! {
    get {
        if _defaultPublicHttpHeader == nil {
            _defaultPublicHttpHeader = XTIHTTPHeaders()
        }
        let bundleInfo = Bundle.main.infoDictionary

        if _defaultPublicHttpHeader["bundelID"] == nil {
            _defaultPublicHttpHeader["bundelID"] = bundleInfo?["CFBundleIdentifier"] as? String
        }
        if _defaultPublicHttpHeader["UUID"] == nil {
            _defaultPublicHttpHeader["UUID"] = XTIKeyChainTool.default.keyChainUuid
        }
        if _defaultPublicHttpHeader["appVersion"] == nil {
            _defaultPublicHttpHeader["appVersion"] = bundleInfo?["CFBundleShortVersionString"] as? String
        }
        if _defaultPublicHttpHeader["systemVersion"] == nil {
            _defaultPublicHttpHeader["systemVersion"] = UIDevice.current.systemVersion
        }
        return _defaultPublicHttpHeader
    } set {
        _defaultPublicHttpHeader = newValue
    }
}

/// 网络请求签名，如果设置了该属性，所有的网络请求都会调用，如果某一个网络请求不需要可以继承XTIBaseRequest，然后重写signature方法
public static var defaultSignature: ((_ parameters: XTIParameters) -> String)!
```

### XTIBaseRequest

```swift
/// 网络请求成功的回调
public typealias XTIRequestCompletedCallback = ((_ requset: XTIBaseRequest?, _ result: Any?) -> ())

/// 网络请求失败的回调
public typealias XTIRequestErrorCallback = ((_ requset: XTIBaseRequest?, _ error: Error?) -> ())

/// 文件上传下载进度的回调
public typealias XTIProgressCallback = ((_ progress: Progress) -> ())

/// 文件下载成功的回调
public typealias XTIDownloadCompletedCallback = ((_ filePath: URL?) -> ())
public class XTIBaseRequest {

    /// 单例
    public static var `default`: XTIBaseRequest
    
    /// 是否打印接口响应的原始数据
    public var iSLogRawData: Bool
    /// 是否需要签名
    public var isNeedSign: Bool! = true
    
    /// HttpMethod，仅支持post or get
    public var httpMethod: HTTPMethod!
    
    /// http or https
    public var httpScheme: XTIHttpScheme
    
    /// 服务器域名，包括端口号，80、443可以忽略
    public var hostName: String
    
    /// 具体服务，域名后面的那一串
    public var serviceName: String!
    
    /// 请求响应数据的模型类
    public var resultClass: HandyJSON.Type!
    
    
    // MARK: - Method
    
    public init()
    
    /// 构造请求参数，如果是POST则放在body里面，如果是GET则拼接在URL后面
    ///
    /// - Returns: 参数字典
    public func buildParameters() -> XTIParameters
    
    public var fileType: String!
    /// 上传文件请求时重写它，
    /// 有 application/atom+xml, application/ecmascript, application/EDI-X12, application/EDIFACT, application/json, application/javascript, application/octet-stream, application/ogg, application/pdf, application/postscript, application/rdf+xml, application/rss+xml, application/soap+xml, application/font-woff, application/xhtml+xml, application/xml, application/xml-dtd, application/xop+xml, application/zip, application/gzip, audio/mp4, audio/mpeg, audio/ogg, audio/vorbis, audio/vnd.rn-realaudio, audio/vnd.wave, audio/webm, audio/x-flac, image/gif, image/jpeg, image/png, image/webp, image/svg+xml, image/tiff, model/example, model/iges, model/mesh, model/vrml, model/x3d+binary, model/x3d+vrml, model/x3d+xml, text/css, text/csv, text/html, text/plain, text/vcard, text/xml, video/mpeg, video/mp4, video/ogg, video/quicktime, video/webm, video/x-matroska, video/x-ms-wmv, video/x-flv ···等类型
    /// - Returns: 返回文件类型
    public func getFileType() -> String
    
    /// 签名，如果继承，可以为每个请求实现不同的签名方式
    ///     该函数根据自己的需求实现，建议将参数字典转换成json字符串然后取这段字符串的签名
    /// 公共参数放置在请求头里面
    /// - Returns: 返回签名，格式："sign=sign"
    public func signature(_ parameters: XTIParameters!) -> String
    
    // MARK: - 发起请求
    
    /// post网络请求，域名等信息使用XTINetWorkConfig的配置，只需要传入服务名和参数及回调的闭包，适用于一个方法管理一个网络请求
    ///
    /// - Parameters:
    ///   - serviceName: 服务名
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func post(serviceName: String!,
                     parameters: XTIParameters! = nil,
                     resultClass resultType: HandyJSON.Type! = nil,
                     completed completedCallback: XTIRequestCompletedCallback!,
                     error errorCallback: XTIRequestErrorCallback!)
    
    /// post网络请求，不使用XTINetWorkConfig的域名信息，适用于多台服务器网络请求
    ///
    /// - Parameters:
    ///   - url: 网络请求的地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func post(url: String!,
                     parameters: XTIParameters! = nil,
                     resultClass resultType: HandyJSON.Type! = nil,
                     completed completedCallback: XTIRequestCompletedCallback!,
                     error errorCallback: XTIRequestErrorCallback!)
    
    /// get网络请求，域名等信息使用XTINetWorkConfig的配置，只需要传入服务名和参数及回调的闭包，适用于一个方法管理一个网络请求
    ///
    /// - Parameters:
    ///   - serviceName: 服务名
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func get(serviceName: String!,
                    parameters: XTIParameters! = nil,
                    resultClass resultType: HandyJSON.Type! = nil,
                    completed completedCallback: XTIRequestCompletedCallback!,
                    error errorCallback: XTIRequestErrorCallback!)
    
    /// get网络请求，不使用XTINetWorkConfig的域名信息，适用于多台服务器网络请求
    ///
    /// - Parameters:
    ///   - url: 网络请求的地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func get(url: String!,
                    parameters: XTIParameters! = nil,
                    resultClass resultType: HandyJSON.Type! = nil,
                    completed completedCallback: XTIRequestCompletedCallback!,
                    error errorCallback: XTIRequestErrorCallback!)
    
    /// 汇总的网络请求，除了回调都有默认参数，默认参数取XTINetWorkConfig里的配置，默认参数可以在初始化对象的时候设置，如果一个类管理一个接口可以在子类里设置所有的默认参数
    ///
    /// - Parameters:
    ///   - method: HttpMethod，仅支持post or get
    ///   - scheme: HttpScheme, http or https
    ///   - host: 域名    非约定端口的请求请带上端口号
    ///   - service: 服务名
    ///   - parameters: 参数，可以传递进去，如果使用一个类管理一个接口请在buildParameters方法里构造参数
    ///   - result: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func send(_ method: HTTPMethod! = nil,
                     httpScheme scheme: XTIHttpScheme! = nil,
                     hostName host: String! = nil,
                     serviceName service: String! = nil,
                     parameters: XTIParameters! = nil,
                     resultClass resultType: HandyJSON.Type! = nil,
                     completed completedCallback: XTIRequestCompletedCallback!,
                     error errorCallback: XTIRequestErrorCallback!)
    
    /// 汇总的网络请求，默认参数取XTINetWorkConfig里的配置
    ///
    /// - Parameters:
    ///   - method: HttpMethod，仅支持post or get
    ///   - url: 网络地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func send(_ method: HTTPMethod! = nil,
                     url: String!,
                     parameters: XTIParameters! = nil,
                     resultClass resultType: HandyJSON.Type! = nil,
                     completed completedCallback: XTIRequestCompletedCallback!,
                     error errorCallback: XTIRequestErrorCallback!)
    
    // MARK: - 文件上传
    
    /// 文件上传，适用于一个类管理一个接口，可以在子类里设置所有的默认参数
    ///
    /// - Parameters:
    ///   - progressCallback: 进度
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func upload(_ progressCallback: XTIProgressCallback! = nil,
                       completedCallback: XTIRequestCompletedCallback! = nil,
                       errorCallback: XTIRequestErrorCallback! = nil)
    
    /// 文件上传，适用于用单例一个方法管理一个请求
    ///     文件上传时请将文件转成Data放置在parameters里
    /// - Parameters:
    ///   - url: 上传的地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - progressCallback: 进度
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func upload(_ url: String!,
                       parameters: XTIParameters!,
                       resultClass resultType: HandyJSON.Type! = nil,
                       progress progressCallback: XTIProgressCallback! = nil,
                       completed completedCallback: XTIRequestCompletedCallback! = nil,
                       error errorCallback: XTIRequestErrorCallback! = nil)
    
    // MARK: - 文件下载
    
    /// 文件下载(该方法仅适用于单个文件，如果文件很多推荐使用TYDownloadManager) <比较鸡肋>
    ///
    /// - Parameters:
    ///   - url: 文件地址
    ///   - filePath: 文件存放路径，如果为空则放置在/Library/Caches
    ///   - progressCallback: 下载进度回调
    ///   - completedCallback: 下载成功的回调
    ///   - errorCallback: 下载失败的回调
    public static func download(_ url: String,
                                filePath: URL! = nil,
                                progressCallback: XTIProgressCallback! = nil,
                                completedCallback: XTIDownloadCompletedCallback! = nil,
                                errorCallback: XTIRequestErrorCallback! = nil)
}
```

> 具体的实现及DEMO请访问[XTInputKit](https://github.com/xt-input/XTInputKit)

