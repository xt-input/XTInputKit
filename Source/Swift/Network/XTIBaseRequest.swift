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
public typealias XTIRequestErrorCallback = ((_ requset: XTIBaseRequest?, _ error: NSError?) -> ())

/// 文件上传下载进度的回调
public typealias XTIProgressCallback = ((_ progress: Progress) -> ())

/// 文件下载成功的回调
public typealias XTIDownloadCompletedCallback = ((_ filePath: URL?) -> ())

public class XTIBaseRequest {
    /// 是否打印接口响应的原始数据
    fileprivate var _iSLogRawData: Bool!
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
    
    /// HttpMethod，仅支持post or get
    public var httpMethod: HTTPMethod!
    
    /// http or https
    fileprivate var _httpScheme: XTIHttpScheme!
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
    
    /// 服务器域名，包括端口号，80、443可以忽略
    fileprivate var _hostName: String!
    public var hostName: String {
        get {
            if (_hostName == nil && XTINetWorkConfig.defaultHostName == nil) || (_hostName.isEmpty && XTINetWorkConfig.defaultHostName.isEmpty) {
                fatalError("服务器地址不能为空！")
            }
            if _hostName == nil {
                return XTINetWorkConfig.defaultHostName
            }
            return _hostName
        } set {
            _hostName = newValue
        }
    }
    
    /// 具体服务，域名后面的那一串
    public var serviceName: String!
    
    /// 是否需要签名
    public var isSign: Bool!
    
    /// 请求响应数据的模型类
    public var result: HandyJSON!
    
    fileprivate var httpManager: SessionManager!
    fileprivate var postParameters: XTIParameters!
    fileprivate var headers: XTIHTTPHeaders!
    
    public init() {
        isSign = true
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.httpAdditionalHeaders!["Content-Type"] = XTINetWorkConfig.defaultContentType
        configuration.timeoutIntervalForRequest = XTINetWorkConfig.defaultTimeoutInterval
        configuration.httpMaximumConnectionsPerHost = XTINetWorkConfig.defaultHttpMaximumConnectionsPerHost
        httpManager = SessionManager(configuration: configuration)
    }
    
    /// 构造post参数
    ///
    /// - Returns: post参数字典
    public func buildPostParameters() -> XTIParameters {
        return XTIParameters()
    }
    
    /// 构造get参数
    ///
    /// - Returns: get参数字典
    public func buildGetParameters() -> XTIHTTPHeaders {
        return XTIHTTPHeaders()
    }
    
    /// 上传文件请求时重写它，
    /// 有 application/atom+xml, application/ecmascript, application/EDI-X12, application/EDIFACT, application/json, application/javascript, application/octet-stream, application/ogg, application/pdf, application/postscript, application/rdf+xml, application/rss+xml, application/soap+xml, application/font-woff, application/xhtml+xml, application/xml, application/xml-dtd, application/xop+xml, application/zip, application/gzip, audio/mp4, audio/mpeg, audio/ogg, audio/vorbis, audio/vnd.rn-realaudio, audio/vnd.wave, audio/webm, audio/x-flac, image/gif, image/jpeg, image/png, image/webp, image/svg+xml, image/tiff, model/example, model/iges, model/mesh, model/vrml, model/x3d+binary, model/x3d+vrml, model/x3d+xml, text/css, text/csv, text/html, text/plain, text/vcard, text/xml, video/mpeg, video/mp4, video/ogg, video/quicktime, video/webm, video/x-matroska, video/x-ms-wmv, video/x-flv ···等类型
    /// - Returns: 返回文件类型
    public func fileType() -> String {
        return "image/jpeg"
    }
    
    /// 签名
    ///     该函数根据自己的需求实现，建议将参数字典转换成json字符串然后取这段字符串的签名
    /// 公共参数也在该函数加入，不需要`?`，会根据返回值自动添加
    /// - Returns: 返回签名
    public func signature() -> String {
        self.postParameters = buildPostParameters()
        self.headers = buildGetParameters()
        var sign: String
        sign = "sign=test"
        // 自定义
        if isSign {
        }
        
        return sign
    }
    
    // MARK: - 发起请求
    
    /// 发起网络请求
    ///
    /// - Parameters:
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func send(_ completedCallback: XTIRequestCompletedCallback! = nil,
                     errorCallback: XTIRequestErrorCallback! = nil) {
        let sign = signature()
        let url = httpScheme.rawValue + hostName + serviceName + (sign == "" ? "" : "?" + sign)
        
        httpManager.request(url,
                            method: httpMethod,
                            parameters: postParameters,
                            encoding: URLEncoding.default,
                            headers: headers).responseJSON { [weak self] res in
            if let strongSelf = self {
                if res.response?.statusCode == 200 {
                    if completedCallback != nil {
//                        completedCallback(strongSelf, strongSelf.responseClass(res.result.value as? [String: Any]))
                    }
                } else {
                    if errorCallback != nil {
                        let code = res.response == nil ? 0 : res.response!.statusCode
                        let error = NSError(domain: "网络错误", code: code, userInfo: nil)
                        errorCallback(strongSelf, error)
                    }
                }
            }
        }
    }
    
    // MARK: - 文件上传
    
    /// 文件上传
    ///     文件上传时请将文件转成Data放置在postParameters里，在子类的buildPostParameters里添加要上传的文件的名字和Data内容
    /// - Parameters:
    ///   - progressCallback: 进度
    ///   - completedCallback: 成功的回调
    ///   - errorCallback: 失败的回调
    public func upload(_ progressCallback: XTIProgressCallback! = nil,
                       completedCallback: XTIRequestCompletedCallback! = nil,
                       errorCallback: XTIRequestErrorCallback! = nil) {
        let sign = signature()
        let url = httpScheme.rawValue + hostName + serviceName + (sign == "" ? "" : "?" + sign)
        
        httpManager.upload(multipartFormData: { [weak self] data in
            if let strongSelf = self {
                strongSelf.postParameters.forEach { key, value in
                    if (value as? Data) == nil {
                        data.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    } else {
                        data.append(value as! Data, withName: key, fileName: key, mimeType: strongSelf.fileType())
                    }
                }
            }
        }, to: url) { [weak self] encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { progress in
                    if progressCallback != nil {
                        progressCallback(progress)
                    }
                }).responseJSON { res in
                    if let strongSelf = self {
                        if res.response?.statusCode == 200 {
                            if completedCallback != nil {
//                                completedCallback(strongSelf, strongSelf.responseClass(res.result.value as! [String: Any]))
                            }
                        } else {
                            if errorCallback != nil {
                                let code = res.response == nil ? 0 : res.response!.statusCode
                                let error = NSError(domain: "上传失败", code: code, userInfo: nil)
                                errorCallback(strongSelf, error)
                            }
                        }
                    }
                }
            case .failure(let encodingError):
                if errorCallback != nil {
                    let error = NSError(domain: encodingError.localizedDescription, code: -1, userInfo: nil)
                    errorCallback(self, error)
                }
            }
        }
    }
    
    // MARK: - 文件下载
    
    /// 文件下载(该方法仅适用于单个文件，如果文件很多推荐使用TYDownloadManager)
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
            let statusCode = res.response == nil ? 0 : res.response!.statusCode
            if res.response?.statusCode == 200 {
                if completedCallback != nil {
                    completedCallback(res.temporaryURL)
                }
            } else {
                if errorCallback != nil {
                    let error = NSError(domain: "下载失败", code: statusCode, userInfo: nil)
                    errorCallback(nil, error)
                }
            }
        }
    }
}
