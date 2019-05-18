//
//  XTIBaseRequest.swift
//  XTInputKit
//
//  Created by Input on 2018/3/16.
//  Copyright © 2018年 input. All rights reserved.
//

import Alamofire
import HandyJSON

/// 网络请求成功的回调
public typealias XTIRequestSuccessCallback = (DataResponse<String>?, Any?) -> Void

/// 网络请求失败的回调
public typealias XTIRequestErrorCallback = (DataResponse<String>?, Error?) -> Void

/// 网络请求完成的回调
public typealias XTIRequestCompleteCallback = (DataResponse<String>?, Any?, Error?) -> Void

/// 文件上传下载进度的回调
public typealias XTIProgressCallback = (Progress) -> Void

open class XTIBaseRequest: RequestInterceptor {
    fileprivate var _iSLogRawData: Bool!
    /// 是否打印接口响应的原始数据
    public var iSLogRawData: Bool {
        get {
            if _iSLogRawData == nil {
                _iSLogRawData = XTINetWorkConfig.iSLogRawData
            }
            return _iSLogRawData
        } set {
            _iSLogRawData = newValue
        }
    }

    /// 是否需要签名
    public var isNeedSign: Bool! = true

    fileprivate var _httpMethod: HTTPMethod!

    /// HttpMethod，仅支持post or get，默认post
    public var httpMethod: HTTPMethod! {
        get {
            if _httpMethod == nil {
                return .post
            }
            return _httpMethod
        } set {
            _httpMethod = newValue
        }
    }

    fileprivate var _encoding: ParameterEncoding!
    public var encoding: ParameterEncoding! {
        get {
            if _encoding == nil {
                _encoding = XTINetWorkConfig.defaultEncoding
            }
            return _encoding
        } set {
            _encoding = newValue
        }
    }

    fileprivate var _httpScheme: XTIHttpScheme!
    /// http or https
    public var httpScheme: XTIHttpScheme {
        get {
            if _httpScheme == nil {
                return XTINetWorkConfig.defaultHttpScheme
            }
            return _httpScheme
        } set {
            _httpScheme = newValue
        }
    }

    fileprivate var _hostName: String!
    /// 服务器域名，包括端口号，80、443可以忽略
    public var hostName: String {
        get {
            if _hostName == nil || _hostName.isEmpty {
                if XTINetWorkConfig.defaultHostName == nil || XTINetWorkConfig.defaultHostName.isEmpty {
                    fatalError("服务器地址不能为空！")
                }
                return XTINetWorkConfig.defaultHostName
            }
            return _hostName
        } set {
            _hostName = newValue
        }
    }

    /// 具体服务，域名后面的那一串
    public var serviceName: String!

    /// 请求响应数据的模型类
    public var resultClass: HandyJSON.Type?
    fileprivate static var _httpManager: Session!
    fileprivate static var httpManager: Session {
        if _httpManager == nil {
            let configuration = URLSessionConfiguration.default
            configuration.headers = HTTPHeaders.default
            configuration.timeoutIntervalForRequest = XTINetWorkConfig.defaultTimeoutInterval
            configuration.httpMaximumConnectionsPerHost = XTINetWorkConfig.defaultHttpMaximumConnectionsPerHost
            _httpManager = Session(configuration: configuration)
        }
        return _httpManager
    }

    fileprivate var _httpManager: Session!

    fileprivate var httpManager: Session {
        if isUserSharedSession {
            return XTIBaseRequest.httpManager
        } else {
            return _httpManager
        }
    }

    fileprivate var parameters: XTIParameters!
    public var result: DataResponse<String>!

    public static var isUserSharedSession: Bool = true

    public var isUserSharedSession: Bool! {
        didSet {
            if !oldValue && isUserSharedSession {
                let configuration = URLSessionConfiguration.default
                configuration.headers = HTTPHeaders.default
                configuration.timeoutIntervalForRequest = XTINetWorkConfig.defaultTimeoutInterval
                configuration.httpMaximumConnectionsPerHost = XTINetWorkConfig.defaultHttpMaximumConnectionsPerHost
                _httpManager = Session(configuration: configuration)
            }
        }
    }

    // MARK: - Method

    public init() {
        self.isUserSharedSession = XTIBaseRequest.isUserSharedSession
    }

    /// 构造请求参数，如果是POST则放在body里面，如果是GET则拼接在URL后面
    ///
    /// - Returns: 参数字典
    open func buildParameters() -> XTIParameters {
        if parameters == nil {
            parameters = XTIParameters()
        }
        return parameters
    }

    public var fileType: String!
    /// 上传文件请求时重写它，
    /// 有 application/atom+xml, application/ecmascript, application/EDI-X12, application/EDIFACT, application/json, application/javascript, application/octet-stream, application/ogg, application/pdf, application/postscript, application/rdf+xml, application/rss+xml, application/soap+xml, application/font-woff, application/xhtml+xml, application/xml, application/xml-dtd, application/xop+xml, application/zip, application/gzip, audio/mp4, audio/mpeg, audio/ogg, audio/vorbis, audio/vnd.rn-realaudio, audio/vnd.wave, audio/webm, audio/x-flac, image/gif, image/jpeg, image/png, image/webp, image/svg+xml, image/tiff, model/example, model/iges, model/mesh, model/vrml, model/x3d+binary, model/x3d+vrml, model/x3d+xml, text/css, text/csv, text/html, text/plain, text/vcard, text/xml, video/mpeg, video/mp4, video/ogg, video/quicktime, video/webm, video/x-matroska, video/x-ms-wmv, video/x-flv ···等类型
    /// - Returns: 返回文件类型
    open func getFileType() -> String {
        if fileType != nil {
            return fileType
        }
        return "image/jpeg"
    }

    /// 签名，如果继承，可以为每个请求实现不同的签名方式
    ///     该函数根据自己的需求实现，建议将参数字典转换成json字符串然后取这段字符串的签名
    /// 公共参数放置在请求头里面
    /// - Returns: 返回签名，格式："sign=sign"
    open func signature(_ parameters: XTIParameters!) -> String {
        if XTINetWorkConfig.defaultSignature != nil && isNeedSign {
            return XTINetWorkConfig.defaultSignature(parameters)
        }
        return ""
    }

    // MARK: - 发起请求

    /// post网络请求，域名等信息使用XTINetWorkConfig的配置，只需要传入服务名和参数及回调的闭包，适用于一个方法管理一个网络请求
    ///
    /// - Parameters:
    ///   - serviceName: 服务名
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 请求完成的回调
    ///   - successCallBack: 成功的回调
    ///   - errorCallback: 失败的回调
    open func post(serviceName: String,
                   parameters: XTIParameters! = nil,
                   resultClass resultType: HandyJSON.Type! = nil,
                   completed completedCallback: XTIRequestCompleteCallback! = nil,
                   success successCallBack: XTIRequestSuccessCallback! = nil,
                   error errorCallback: XTIRequestErrorCallback! = nil) {
        send(.post, httpScheme: nil, hostName: nil, serviceName: serviceName, parameters: parameters, resultClass: resultType, completed: completedCallback, success: successCallBack, error: errorCallback)
    }

    /// post网络请求，不使用XTINetWorkConfig的域名信息，适用于多台服务器网络请求
    ///
    /// - Parameters:
    ///   - url: 网络请求的地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 请求完成的回调
    ///   - successCallBack: 成功的回调
    ///   - errorCallback: 失败的回调
    open func post(url: String,
                   parameters: XTIParameters! = nil,
                   resultClass resultType: HandyJSON.Type! = nil,
                   completed completedCallback: XTIRequestCompleteCallback! = nil,
                   success successCallBack: XTIRequestSuccessCallback! = nil,
                   error errorCallback: XTIRequestErrorCallback! = nil) {
        send(.post, url: url, parameters: parameters, resultClass: resultType, completed: completedCallback, success: successCallBack, error: errorCallback)
    }

    /// get网络请求，域名等信息使用XTINetWorkConfig的配置，只需要传入服务名和参数及回调的闭包，适用于一个方法管理一个网络请求
    ///
    /// - Parameters:
    ///   - serviceName: 服务名
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 请求完成的回调
    ///   - successCallBack: 成功的回调
    ///   - errorCallback: 失败的回调
    open func get(serviceName: String,
                  parameters: XTIParameters! = nil,
                  resultClass resultType: HandyJSON.Type! = nil,
                  completed completedCallback: XTIRequestCompleteCallback! = nil,
                  success successCallBack: XTIRequestSuccessCallback! = nil,
                  error errorCallback: XTIRequestErrorCallback! = nil) {
        send(.get, httpScheme: nil, hostName: nil, serviceName: serviceName, parameters: parameters, resultClass: resultType, completed: completedCallback, success: successCallBack, error: errorCallback)
    }

    /// get网络请求，不使用XTINetWorkConfig的域名信息，适用于多台服务器网络请求
    ///
    /// - Parameters:
    ///   - url: 网络请求的地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 请求完成的回调
    ///   - errorCallback: 失败的回调
    open func get(url: String,
                  parameters: XTIParameters! = nil,
                  resultClass resultType: HandyJSON.Type! = nil,
                  completed completedCallback: XTIRequestCompleteCallback! = nil,
                  success successCallBack: XTIRequestSuccessCallback! = nil,
                  error errorCallback: XTIRequestErrorCallback! = nil) {
        send(.get, url: url, parameters: parameters, resultClass: resultType, completed: completedCallback, success: successCallBack, error: errorCallback)
    }

    /// 汇总的网络请求，除了回调都有默认参数，默认参数取XTINetWorkConfig里的配置，默认参数可以在初始化对象的时候设置，如果一个类管理一个接口可以在子类里设置所有的默认参数
    ///
    /// - Parameters:
    ///   - method: HttpMethod，仅支持post or get
    ///   - scheme: HttpScheme, http or https
    ///   - host: 域名    非约定端口的请求请带上端口号
    ///   - service: 服务名
    ///   - parameters: 参数，可以传递进去，如果使用一个类管理一个接口请在buildParameters方法里构造参数
    ///   - result: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 请求完成的回调
    ///   - successCallBack: 成功的回调
    ///   - errorCallback: 失败的回调
    open func send(_ method: HTTPMethod! = nil,
                   httpScheme scheme: XTIHttpScheme! = nil,
                   hostName host: String! = nil,
                   serviceName service: String! = nil,
                   parameters: XTIParameters! = nil,
                   resultClass resultType: HandyJSON.Type! = nil,
                   completed completedCallback: XTIRequestCompleteCallback! = nil,
                   success successCallBack: XTIRequestSuccessCallback! = nil,
                   error errorCallback: XTIRequestErrorCallback! = nil) {
        let tempScheme = scheme == nil ? httpScheme : scheme!
        let tempHost = host == nil ? hostName : host!
        var tempServiceName = service == nil ? serviceName == nil ? "" : serviceName! : service!
        if tempServiceName.first == "/" {
            tempServiceName.removeFirst()
        }
        let url = tempScheme.rawValue + tempHost.replacingOccurrences(of: "/", with: "") + "/" + tempServiceName
        send(method, url: url, parameters: parameters, resultClass: resultType, completed: completedCallback, success: successCallBack, error: errorCallback)
    }

    /// 汇总的网络请求，默认参数取XTINetWorkConfig里的配置
    ///
    /// - Parameters:
    ///   - method: HttpMethod，仅支持post or get
    ///   - url: 网络地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 请求完成的回调
    ///   - successCallBack: 成功的回调
    ///   - errorCallback: 失败的回调
    public func send(_ method: HTTPMethod! = nil,
                     url: String,
                     parameters: XTIParameters! = nil,
                     resultClass resultType: HandyJSON.Type! = nil,
                     completed completedCallback: XTIRequestCompleteCallback! = nil,
                     success successCallBack: XTIRequestSuccessCallback! = nil,
                     error errorCallback: XTIRequestErrorCallback! = nil) {
        let tempMethod = method == nil ? httpMethod! : method!
        let tempParameters = parameters == nil ? buildParameters() : parameters!
        var tempHeaders = XTINetWorkConfig.defaultopenHttpHeader!
        let sign = signature(tempParameters)
        if sign != "" {
            tempHeaders["sign"] = sign
        }

        httpManager.request(url,
                            method: tempMethod,
                            parameters: tempParameters,
                            encoding: encoding,
                            headers: tempHeaders)
            .responseString { [weak self] res in
                if let strongSelf = self {
                    strongSelf.requestCallback(res, resultClass: resultType, completed: completedCallback, success: successCallBack, error: errorCallback)
                }
            }
    }

    // MARK: - 文件上传

    /// 文件上传，适用于一个类管理一个接口，可以在子类里设置所有的默认参数
    ///
    /// - Parameters:
    ///   - progressCallback: 进度
    ///   - completedCallback: 请求完成的回调
    ///   - successCallBack: 成功的回调
    ///   - errorCallback: 失败的回调
    open func upload(_ progressCallback: XTIProgressCallback! = nil,
                     completed completedCallback: XTIRequestCompleteCallback! = nil,
                     successCallBack: XTIRequestSuccessCallback! = nil,
                     errorCallback: XTIRequestErrorCallback! = nil) {
        let url = httpScheme.rawValue + hostName + serviceName
        upload(url, parameters: buildParameters(), progress: progressCallback, completed: completedCallback, success: successCallBack, error: errorCallback)
    }

    /// 文件上传，适用于用单例一个方法管理一个请求
    ///     文件上传时请将文件转成Data放置在parameters里
    /// - Parameters:
    ///   - url: 上传的地址
    ///   - parameters: 参数
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - progressCallback: 进度
    ///   - completedCallback: 请求完成的回调
    ///   - successCallBack: 成功的回调
    ///   - errorCallback: 失败的回调
    public func upload(_ url: String,
                       parameters: XTIParameters!,
                       resultClass resultType: HandyJSON.Type! = nil,
                       progress progressCallback: XTIProgressCallback! = nil,
                       completed completedCallback: XTIRequestCompleteCallback! = nil,
                       success successCallBack: XTIRequestSuccessCallback! = nil,
                       error errorCallback: XTIRequestErrorCallback! = nil) {
        let sign = signature(parameters)
        var tempHeaders = XTINetWorkConfig.defaultopenHttpHeader!
        if sign != "" {
            tempHeaders["sign"] = sign
        }
        tempHeaders["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        httpManager.upload(multipartFormData: { [weak self] data in
            if let strongSelf = self {
                parameters.forEach { key, value in
                    if (value as? Data) == nil {
                        data.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    } else {
                        data.append(value as! Data, withName: key, fileName: key, mimeType: strongSelf.getFileType())
                    }
                }
            }
        }, to: url, method: .post, headers: tempHeaders, interceptor: self)
            .uploadProgress(closure: progressCallback)
            .responseString {[weak self] response in
                if let strongSelf = self {
                    strongSelf.requestCallback(response, resultClass: resultType, completed: completedCallback, success: successCallBack, error: errorCallback)
                }
            }
    }

    /// 网络请求结束后的结果处理
    ///
    /// - Parameters:
    ///   - result: 响应数据
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 请求完成的回调
    ///   - successCallBack: 成功的回调
    ///   - errorCallback: 失败的回调
    fileprivate func requestCallback(_ result: DataResponse<String>,
                                     resultClass resultType: HandyJSON.Type!,
                                     completed completedCallback: XTIRequestCompleteCallback! = nil,
                                     success successCallBack: XTIRequestSuccessCallback! = nil,
                                     error errorCallback: XTIRequestErrorCallback! = nil) {
        outRawData(result)
        self.result = result
        var error: Error?
        var resultValue: Any!

        if let tempResponse = result.response {
            if tempResponse.statusCode == 200 {
                do {
                    resultValue = try JSONSerialization.jsonObject(with: result.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                } catch {
                    resultValue = result.value
                }
                if resultType != nil {
                    resultValue = resultType?.deserialize(from: result.value) as Any
                } else if resultClass != nil {
                    resultValue = resultClass?.deserialize(from: result.value) as Any
                }
            } else {
                resultValue = result.value
                let domain = HTTPURLResponse.localizedString(forStatusCode: tempResponse.statusCode)
                var info = [String: Any]()
                if let tempUrl = tempResponse.url {
                    info["url"] = tempUrl
                }
                error = NSError(domain: domain, code: tempResponse.statusCode, userInfo: info)
            }
        } else {
            error = result.error
        }

        if completedCallback != nil {
            completedCallback(result, resultValue, error)
        }

        if let tempError = error {
            if errorCallback != nil {
                errorCallback(result, tempError)
            }
        } else {
            if successCallBack != nil {
                successCallBack(result, resultValue)
            }
        }
    }

    // MARK: - 文件下载

    /// 文件下载(该方法仅适用于单个文件，如果文件很多推荐使用TYDownloadManager) <比较鸡肋>
    ///
    /// - Parameters:
    ///   - url: 文件地址
    ///   - filePath: 文件存放路径，如果为空则放置在/Library/Caches
    ///   - progressCallback: 下载进度回调
    ///   - completedCallback: 请求完成的回调
    ///   - successCallBack: 下载成功的回调
    ///   - errorCallback: 下载失败的回调
    public static func download(_ url: String,
                                filePath: URL! = nil,
                                progressCallback: XTIProgressCallback! = nil,
                                completed completedCallback: XTIRequestCompleteCallback! = nil,
                                successCallBack: XTIRequestSuccessCallback! = nil,
                                errorCallback: XTIRequestErrorCallback! = nil) {
        let downloadManager = Session.default.download(url) { (_, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
            var flieURL: URL
            let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            flieURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            if filePath != nil {
                flieURL = filePath
            }
            return (flieURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        downloadManager.downloadProgress { progress in
            if progressCallback != nil {
                progressCallback(progress)
            }
        }.responseString { result in
            let code = result.response == nil ? 0 : result.response!.statusCode
            if code == 200 {
                if successCallBack != nil {
                    successCallBack(nil, result)
                }
                if completedCallback != nil {
                    completedCallback(nil, result, nil)
                }
            } else {
                let domain = HTTPURLResponse.localizedString(forStatusCode: code)
                let error = NSError(domain: domain, code: code, userInfo: nil)

                if errorCallback != nil {
                    errorCallback(nil, error)
                }
                if completedCallback != nil {
                    completedCallback(nil, nil, error)
                }
            }
        }
    }

    /// 打印原始数据，可以在该函数里面读取Cookie的值
    ///
    /// - Parameter result: 原始数据
    open func outRawData(_ result: DataResponse<String>) {
        if iSLogRawData {
            XTILoger.default.debug(result)
        }
    }

    deinit {
        #if DEBUG
            XTILoger.default.info(self)
        #endif
    }
}
