//
//  XTICacheManager.swift
//  XTInputKit
//
//  Created by xt-input on 2019/7/23.
//

import Cache

public enum DaisyExpiry {
    case never
    case seconds(TimeInterval)
    case date(Date)

    public var expiry: Expiry {
        switch self {
        case .never:
            return Expiry.never
        case let .seconds(seconds):
            return Expiry.seconds(seconds)
        case let .date(date):
            return Expiry.date(date)
        }
    }

    public var isExpired: Bool {
        return expiry.isExpired
    }
}

public struct XTICacheManager: XTISharedProtocol {
    fileprivate var storage: Storage<String>?

    var expiry: DaisyExpiry {
        didSet {
            let diskConfig = DiskConfig(
                name: "XTIDaisyCache",
                expiry: expiry.expiry
            )
            let memoryConfig = MemoryConfig(expiry: expiry.expiry)
            do {
                storage = try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: String.self))
            } catch {
                xtiloger.error(error)
            }
        }
    }

    public init() {
        self.expiry = .never
    }

    /// 清除所有缓存
    ///
    /// - Parameter completion: completion
    public func removeAllCache(completion: @escaping (_ isSuccess: Bool) -> Void) {
        storage?.async.removeAll(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }

    /// 根据key值清除缓存
    ///
    /// - Parameters:
    ///   - cacheKey: cacheKey
    ///   - completion: completion
    public func removeObjectCache(_ cacheKey: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        storage?.async.removeObject(forKey: cacheKey, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }

    /// 读取缓存
    ///
    /// - Parameter key: key
    /// - Returns: model
    fileprivate func objectSync(forKey key: String) -> String? {
        do {
            /// 过期清除缓存
            if let isExpire = try storage?.isExpiredObject(forKey: key), isExpire {
                removeObjectCache(key) { _ in }
                return nil
            } else {
                return (try storage?.object(forKey: key)) ?? nil
            }
        } catch {
            return nil
        }
    }

    /// 异步缓存
    ///
    /// - Parameters:
    ///   - object: model
    ///   - key: key
    fileprivate func setObject(_ object: String, forKey key: String) {
        storage?.async.setObject(object, forKey: key, expiry: nil, completion: { _ in })
    }

    func setCache(_ url: String,
                  value: String,
                  parameters: XTIParameters? = nil,
                  exclude: [String]? = nil) {
        let key = cacheKey(url, parameters: parameters, exclude: exclude)

        setObject(value, forKey: key)
    }

    func getCache(_ url: String,
                  parameters: XTIParameters? = nil,
                  exclude: [String]? = nil) -> String? {
        let key = cacheKey(url, parameters: parameters, exclude: exclude)
        let cache = objectSync(forKey: key)
        return cache
    }
}

extension XTICacheManager {
    public func cacheKey(_ url: String,
                         parameters: XTIParameters? = nil,
                         exclude: [String]? = nil) -> String {
        if let filterParams = parameters?.filter({ (key, _) -> Bool in
            exclude?.contains(where: { (value) -> Bool in
                key != value
            }) ?? false
        }) {
            let str = "\(url)" + "\(sort(filterParams))"
            return MD5(str)
        } else {
            return MD5(url)
        }
    }

    public func sort(_ parameters: [String: Any]?) -> String {
        var sortParams = ""
        if let params = parameters {
            let sortArr = params.keys.sorted { $0 < $1 }
            sortArr.forEach { str in
                if let value = params[str] {
                    sortParams = sortParams.appending("\(str)=\(value)")
                } else {
                    sortParams = sortParams.appending("\(str)=")
                }
            }
        }
        return sortParams
    }
}
