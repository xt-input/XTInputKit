//
//  XTIKeyChainTool.swift
//  XTInputKit
//
//  Created by xt-input on 2018/3/16.
//  Copyright © 2018年 input. All rights reserved.
//

import Foundation
import Security

/// KeyChain的封装，需要开启项目配置的Capabilities->Keychain Sharing
open class XTIKeyChainTool: XTISharedProtocol {
    public required init() {
    }

    /// 是否同步到iCloud
    public var synchronizable: Bool!
    /// 应用分组
    public var accessGroup: String!

    /// 同步到iCloud
    public static let iCloud = XTIKeyChainTool(synchronizable: true)

    fileprivate var bundleNmae = Bundle.main.bundleIdentifier == nil ? "cn.tcoding.XTInputKit" : Bundle.main.bundleIdentifier!
    /// 初始化
    ///
    /// - Parameters:
    ///   - synchronizable: 是否同步到iCloud
    ///   - accessGroup: 应用分组，如果需要使用应用分组可以使用它
    public init(synchronizable: Bool = false, accessGroup: String! = nil) {
        self.synchronizable = synchronizable
        self.accessGroup = accessGroup
    }

    fileprivate var _keyChainUuid: String!
    /// 保存在KeyChain里面的UUID，如果不还原手机数据及设置不会被清理掉，可以用来代替openudid
    public var keyChainUuid: String! {
        guard let tempUuid = _keyChainUuid else {
            let key = "\(bundleNmae)-uuid"
            var uuid = XTIKeyChainTool.shared().get(valueTpye: String.self, forKey: key)
            if uuid == nil {
                uuid = (UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString).replacingOccurrences(of: "-", with: "")
                XTIKeyChainTool.shared().set(uuid!, forKey: key)
            }
            return uuid!
        }
        return tempUuid
    }

    /// 将value保存到KeyChain里面去
    ///
    /// - Parameters:
    ///   - value: 值
    ///   - key: 键
    /// - Returns: 操作结果
    @discardableResult public func set<ValueType: DataConvertible>(_ value: ValueType, forKey key: String) -> Bool {
        var keyChainItem = self.initKeyChainDictionary()
        keyChainItem[kSecAttrAccount] = key
        keyChainItem[kSecValueData] = value.data
        switch SecItemAdd(keyChainItem as CFDictionary, nil) {
        case errSecSuccess:
            return true
        case errSecDuplicateItem:
            return SecItemUpdate(keyChainItem as CFDictionary, [kSecValueData: value.data] as CFDictionary) == errSecSuccess
        default:
            return false
        }
    }

    /// 获取保存在KeyChain里面的值
    ///
    /// - Parameters:
    ///   - valueTpye: 值的类型
    ///   - key: 键
    /// - Returns: 值 or nil
    public func get<ValueType: DataConvertible>(valueTpye: ValueType.Type, forKey key: String) -> ValueType! {
        var keyChainItem = self.initKeyChainDictionary()
        keyChainItem[kSecAttrAccount] = key
        keyChainItem[kSecMatchLimit] = kSecMatchLimitOne
        keyChainItem[kSecReturnData] = kCFBooleanTrue

        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(keyChainItem as CFDictionary, UnsafeMutablePointer($0))
        }
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                return nil
            }
            return ValueType(data: data)
        default:
            return nil
        }
    }

    /// 删除KeyChain里面的数据
    ///
    /// - Parameter key: 键，如果没有键则将该应用保存在KeyChain里所以的值都清理掉(不包括keyChainUuid)
    /// - Returns: 操作结果
    @discardableResult public func delete(_ key: String! = nil) -> Bool {
        var keyChainItem = self.initKeyChainDictionary()

        if key == nil {
            keyChainItem[kSecMatchLimit] = kSecMatchLimitAll
            keyChainItem[kSecReturnAttributes] = kCFBooleanTrue
            var result: AnyObject?
            let status = withUnsafeMutablePointer(to: &result) {
                SecItemCopyMatching(keyChainItem as CFDictionary, UnsafeMutablePointer($0))
            }
            switch status {
            case errSecSuccess:
                var keys = [String]()
                if let results = result as? [[AnyHashable: Any]] {
                    for attributes in results {
                        if let account = attributes[kSecAttrAccount as String] as? String {
                            if account != "\(self.bundleNmae)-uuid" { keys.append(account) }
                        }
                    }
                }
                var count = 0
                keys.forEach { value in
                    count += self.delete(value) ? 1 : 0
                }
                return count == keys.count
            default:
                return false
            }
        } else {
            keyChainItem[kSecAttrAccount] = key
            switch SecItemDelete(keyChainItem as CFDictionary) {
            case errSecSuccess:
                return true
            default:
                return false
            }
        }
    }

    fileprivate var _query: [AnyHashable: Any]!

    fileprivate func initKeyChainDictionary() -> [AnyHashable: Any] {
        if self._query == nil {
            var query: [AnyHashable: Any]
            query = [AnyHashable: Any]()
            query[kSecClass] = kSecClassGenericPassword
            query[kSecAttrService] = bundleNmae
            query[kSecAttrAccessible] = kSecAttrAccessibleWhenUnlocked
            query[kSecAttrSynchronizable] = self.synchronizable ? kCFBooleanTrue : kCFBooleanFalse
            query[kSecAttrAccessGroup] = accessGroup
            self._query = query
        }
        return self._query
    }
}

public protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}

public protocol SimpleStruct {}

extension DataConvertible where Self: SimpleStruct {
    public init?(data: Data) {
        guard data.count == MemoryLayout<Self>.size else { return nil }
        self = data.withUnsafeBytes { $0.load(as: Self.self) }
    }

    public var data: Data {
        var value = self
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
}

extension Bool: SimpleStruct, DataConvertible {}

extension Int: SimpleStruct, DataConvertible {}

extension Float: SimpleStruct, DataConvertible {}

extension Double: SimpleStruct, DataConvertible {}

extension String: DataConvertible {
    public init?(data: Data) {
        self.init(data: data, encoding: .utf8)
    }

    public var data: Data {
        return self.data(using: .utf8) ?? Data()
    }
}

extension Data: DataConvertible {
    public init?(data: Data) {
        self = data
    }

    public var data: Data {
        return self
    }
}
