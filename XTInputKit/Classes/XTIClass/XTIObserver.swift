//
//  XTObserver.swift
//  XTInputKit
//
//  Created by xt-input on 2017/4/27.
//  Copyright © 2017年 tcoding.cn. All rights reserved.
//

import Foundation

/// 观察者单元(解决字典强引用导致内存泄露问题)
open class XTIObserverItem: NSObject {
    fileprivate weak var _observerItem: AnyObject?
    public var observerItem: AnyObject? {
        return _observerItem
    }

    public init(_ item: AnyObject) {
        _observerItem = item
    }
}

/// 观察者管理类
open class XTIObserver {
    fileprivate var _observers: [String: XTIObserverItem] = [:]

    public var observers: [String: XTIObserverItem] {
        return _observers
    }
    public init() {
    }
    /// 添加观察者，只能在子类里调用，保护_observers
    ///
    /// - Parameter Object: 需要添加的观察者单元
    public final func addObserver(_ item: XTIObserverItem) {
        if let description = item.observerItem?.description {
            _observers[description] = item
            _observers = observers.filter { (_, value) -> Bool in
                value.observerItem != nil
            }
        }
        // 清理已经被释放的观察者
        _observers = self.observers.filter { (_, value) -> Bool in
            value.observerItem != nil
        }
    }

    /// 移除观察者, 只能在子类里调用，保护_observers
    ///
    /// - Parameter Object: 需要移除的观察者单元
    public final func removeObserver(_ item: XTIObserverItem) {
        if let description = item.observerItem?.description {
            _observers.removeValue(forKey: description)
        }
    }

    /// 移除所有观察者
    open func removeAllObserver() {
        _observers.removeAll()
    }
}
