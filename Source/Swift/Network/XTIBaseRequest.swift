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
public typealias XTIRequestCompletedCallback = ((_ requset: XTIBaseRequest?, _ result: Any?) -> ())

/// 网络请求失败的回调
public typealias XTIRequestErrorCallback = ((_ requset: XTIBaseRequest?, _ error: Error?) -> ())

/// 文件上传下载进度的回调
public typealias XTIProgressCallback = ((_ progress: Progress) -> ())

/// 文件下载成功的回调
public typealias XTIDownloadCompletedCallback = ((_ filePath: URL?) -> ())

public class XTIBaseRequest {
    fileprivate static var _default = XTIBaseRequest()
    /// 单例
    public static var `default`: XTIBaseRequest {
        return _default
    }
    
    fileprivate var _iSLogRawData: Bool!
    /// 是否打印接口响应的原始数据
    public var iSLogRawData: Bool {
        get {
            if _iSLogRawData == nil {
                return XTINetWorkConfig.iSLogRawData
            }
            return _iSLogRawData
        } set {
            _iSLogRawData = newValue
        }
    }
    /// 是否需要签名
    public var isNeedSign: Bool! = true
    
    fileprivate var _httpMethod: HTTPMethod!
    /// HttpMethod，仅支持post or get
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
    public var resultClass: HandyJSON.Type!
    
    fileprivate var httpManager: SessionManager!
    fileprivate var parameters: XTIParameters!
    
    // MARK: - Method
    
    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.httpAdditionalHeaders!["Content-Type"] = XTINetWorkConfig.defaultContentType
        configuration.timeoutIntervalForRequest = XTINetWorkConfig.defaultTimeoutInterval
        configuration.httpMaximumConnectionsPerHost = XTINetWorkConfig.defaultHttpMaximumConnectionsPerHost
        httpManager = SessionManager(configuration: configuration)
    }
    
    /// 构造请求参数，如果是POST则放在body里面，如果是GET则拼接在URL后面
    ///
    /// - Returns: 参数字典
    public func buildParameters() -> XTIParameters {
        if parameters == nil {
            parameters = XTIParameters()
        }
        return parameters
    }
    
    public var fileType: String!
    /// 上传文件请求时重写它，
    /// 有 application/atom+xml, application/ecmascript, application/EDI-X12, application/EDIFACT, application/json, application/javascript, application/octet-stream, application/ogg, application/pdf, application/postscript, application/rdf+xml, application/rss+xml, application/soap+xml, application/font-woff, application/xhtml+xml, application/xml, application/xml-dtd, application/xop+xml, application/zip, application/gzip, audio/mp4, audio/mpeg, audio/ogg, audio/vorbis, audio/vnd.rn-realaudio, audio/vnd.wave, audio/webm, audio/x-flac, image/gif, image/jpeg, image/png, image/webp, image/svg+xml, image/tiff, model/example, model/iges, model/mesh, model/vrml, model/x3d+binary, model/x3d+vrml, model/x3d+xml, text/css, text/csv, text/html, text/plain, text/vcard, text/xml, video/mpeg, video/mp4, video/ogg, video/quicktime, video/webm, video/x-matroska, video/x-ms-wmv, video/x-flv ···等类型
    /// - Returns: 返回文件类型
    public func getFileType() -> String {
        if fileType != nil {
            return fileType
        }
        return "image/jpeg"
    }
    
    /// 签名，如果继承，可以为每个请求实现不同的签名方式
    ///     该函数根据自己的需求实现，建议将参数字典转换成json字符串然后取这段字符串的签名
    /// 公共参数放置在请求头里面
    /// - Returns: 返回签名，格式："sign=sign"
    public func signature(_ parameters: XTIParameters!) -> String {
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
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func post(serviceName: String!,
                     parameters: XTIParameters! = nil,
                     resultClass resultType: HandyJSON.Type! = nil,
                     completed completedCallback: XTIRequestCompletedCallback!,
                     error errorCallback: XTIRequestErrorCallback!) {
        send(.post, httpScheme: nil, hostName: nil, serviceName: serviceName, parameters: parameters, resultClass: resultType, completed: completedCallback, error: errorCallback)
    }
    
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
                     error errorCallback: XTIRequestErrorCallback!) {
        send(.post, url: url, parameters: parameters, resultClass: resultType, completed: completedCallback, error: errorCallback)
    }
    
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
                    error errorCallback: XTIRequestErrorCallback!) {
        send(.get, httpScheme: nil, hostName: nil, serviceName: serviceName, parameters: parameters, resultClass: resultType, completed: completedCallback, error: errorCallback)
    }
    
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
                    error errorCallback: XTIRequestErrorCallback!) {
        send(.get, url: url, parameters: parameters, resultClass: resultType, completed: completedCallback, error: errorCallback)
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
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func send(_ method: HTTPMethod! = nil,
                     httpScheme scheme: XTIHttpScheme! = nil,
                     hostName host: String! = nil,
                     serviceName service: String! = nil,
                     parameters: XTIParameters! = nil,
                     resultClass resultType: HandyJSON.Type! = nil,
                     completed completedCallback: XTIRequestCompletedCallback!,
                     error errorCallback: XTIRequestErrorCallback!) {
        let tempScheme = scheme == nil ? httpScheme : scheme!
        let tempHost = host == nil ? hostName : host!
        let tempServiceName = service == nil ? serviceName! : service!
        
        let url = tempScheme.rawValue + tempHost + tempServiceName
        send(method, url: url, parameters: parameters, resultClass: resultType, completed: completedCallback, error: errorCallback)
    }
    
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
                     error errorCallback: XTIRequestErrorCallback!) {
        let tempMethod = method == nil ? httpMethod! : method!
        let tempParameters = parameters == nil ? buildParameters() : parameters!
        var tempHeaders = XTINetWorkConfig.defaultPublicHttpHeader!
        let sign = signature(tempParameters)
        if sign != "" {
            tempHeaders["sign"] = sign
        }
        httpManager.request(url,
                            method: tempMethod,
                            parameters: tempParameters,
                            encoding: URLEncoding.default,
                            headers: tempHeaders).responseString { [weak self] res in
            if let strongSelf = self {
                strongSelf.requestCallback(res, resultClass: resultType, completed: completedCallback, error: errorCallback)
            }
        }
    }
    
    // MARK: - 文件上传
    
    /// 文件上传，适用于一个类管理一个接口，可以在子类里设置所有的默认参数
    ///
    /// - Parameters:
    ///   - progressCallback: 进度
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func upload(_ progressCallback: XTIProgressCallback! = nil,
                       completedCallback: XTIRequestCompletedCallback! = nil,
                       errorCallback: XTIRequestErrorCallback! = nil) {
        let url = httpScheme.rawValue + hostName + serviceName
        upload(url, parameters: buildParameters(), progress: progressCallback, completed: completedCallback, error: errorCallback)
    }
    
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
                       error errorCallback: XTIRequestErrorCallback! = nil) {
        let sign = signature(parameters)
        var tempHeaders = XTINetWorkConfig.defaultPublicHttpHeader!
        if sign != "" {
            tempHeaders["sign"] = sign
        }
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
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
           to: url, method: .post, headers: tempHeaders) { [weak self] encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { progress in
                    if progressCallback != nil {
                        progressCallback(progress)
                    }
                }).responseString { res in
                    if let strongSelf = self {
                        strongSelf.requestCallback(res, resultClass: resultType, completed: completedCallback, error: errorCallback)
                    }
                }
            case .failure(let encodingError):
                if errorCallback != nil {
                    errorCallback(self, encodingError)
                }
            }
        }
    }
    
    /// 网络请求结束后的结果处理
    ///
    /// - Parameters:
    ///   - result: 响应数据
    ///   - resultType: 返回数据的模型，如果没有该参数则返回数据类型将优先解析成JSON对象，解析失败则是字符串
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    fileprivate func requestCallback(_ result: DataResponse<String>, resultClass resultType: HandyJSON.Type!, completed completedCallback: XTIRequestCompletedCallback!, error errorCallback: XTIRequestErrorCallback!) {
        if iSLogRawData {
            XTILoger.default.info(result)
        }
        if result.result.isSuccess {
            if completedCallback != nil {
                var resultValue: Any!
                do {
                    resultValue = try JSONSerialization.jsonObject(with: result.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                } catch {
                    resultValue = result.result.value
                }
                if resultType != nil {
                    resultValue = resultType.deserialize(from: result.result.value) as Any
                } else if resultClass != nil {
                    resultValue = resultClass.deserialize(from: result.result.value) as Any
                }
                completedCallback(self, resultValue)
            }
        } else {
            if errorCallback != nil {
                errorCallback(self, result.result.error)
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
    ///   - completedCallback: 下载成功的回调
    ///   - errorCallback: 下载失败的回调
    public static func download(_ url: String,
                                filePath: URL! = nil,
                                progressCallback: XTIProgressCallback! = nil,
                                completedCallback: XTIDownloadCompletedCallback! = nil,
                                errorCallback: XTIRequestErrorCallback! = nil) {
        let downloadManager = SessionManager.default.download(url) { (_, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
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
        }.responseJSON { res in
            if res.result.isSuccess {
                if completedCallback != nil {
                    completedCallback(res.temporaryURL)
                }
            } else {
                if errorCallback != nil {
                    errorCallback(nil, res.result.error)
                }
            }
        }
    }
}
