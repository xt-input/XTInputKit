//
//  XTITimer.swift
//  XTInputKit
//
//  Created by xt-input on 2018/5/20.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

public typealias XTITimerItemCallback = (XTITimerItem?) -> Void

/// 计时器任务单元
/// - 观察者需要实现 @objc func countdown(_ item: XTITimerItem)
/// - 在“countdown:”函数里，通过设置 item.isCancel 来中途取消该任务
open class XTITimerItem: XTIObserverItem {
    fileprivate var _count: Int = 0
    /// 本任务是第几次执行
    public var count: Int {
        return self._count
    }

    fileprivate var _sum: Int = 0
    /// 任务一共需要执行多少次
    public var sum: Int {
        return self._sum
    }

    let t = CADisplayLink()

    /// 是否取消
    public var isCancel: Bool! {
        didSet {
            if self.isCancel != nil && (self.isCancel)! {
                self.timer.cancel()
            }
        }
    }

    fileprivate var _labelName: String = ""
    /// 别名，如果一个对象要添加多个计时器需要设置该属性
    public var labelName: String {
        return self._labelName
    }

    fileprivate var timer: DispatchSourceTimer!

    public init(_ item: AnyObject, labelName name: String = "", sum: Int = 0, interval: Double = 1, block: XTITimerItemCallback! = nil) {
        super.init(item)
        t.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        self._sum = sum
        self._labelName = name
        self.timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: DispatchQueue.global(qos: .background))
        self.timer.schedule(wallDeadline: DispatchWallTime.now() + interval, repeating: interval)
        self.timer.setEventHandler { [weak self] in
            if self?.observerItem == nil || (self?.isEnd() != nil && (self?.isEnd())!) {
                self?.timer.cancel()
            } else {
                self?.addCount()
                if block != nil {
                    DispatchQueue.main.async {
                        block(self)
                    }
                } else {
                    let sel = Selector(("countdown:"))
                    let isResponds = self?.observerItem?.responds(to: sel)
                    if isResponds != nil && isResponds! { // 判断观察者有没有实现计时器处理函数
                        self?.observerItem?.performSelector(onMainThread: sel, with: self, waitUntilDone: true, modes: [RunLoop.Mode.common.rawValue])
                    }
                }
            }
        }
        self.timer.resume()
    }

    fileprivate func addCount() {
        self._count += 1
    }

    public func isEnd() -> Bool {
        return self.sum == 0 ? false : self.count == self.sum
    }

    fileprivate func cancel() {
        self.timer.cancel()
    }
}

/// 计时器任务管理
open class XTITimer: XTIObserver {
    /// 添加观察者
    ///     重复添加会覆盖
    /// - Parameters:
    ///   - object: 观察者
    ///   - labelName: 别名，如果一个对象要添加多个计时器需要设置该属性
    ///   - interval: 间隔时间
    ///   - sum: 执行次数，0表示无限次
    ///       - block: 尾随闭包
    open func addObserver(_ object: AnyObject, labelName name: String = "", repeating interval: Double = 1, sum: Int = 0, block: XTITimerItemCallback! = nil) {
        if var description = object.description {
            description += name
            let isNeedAdd: Bool = block != nil || object.responds(to: Selector(("countdown:"))) // 判断是否携带尾随闭包或观察者是否实现"countdown:"函数，如果没有实现就不需要添加该观察者了
            if isNeedAdd {
                if let item = self.observers[description] as? XTITimerItem { // 判断该观察者是否已经添加，如果已经添加先取消该观察者的任务，然后在重新添加
                    item.cancel()
                }
                self.addObserver(XTITimerItem(object, sum: sum, interval: interval, block: block))
            }
        }
        // 去除被释放了的的观察者的任务
        let keyArray = observers.filter { (_, item) -> Bool in
            item.observerItem == nil
        }
        keyArray.values.forEach { item in
            (item as? XTITimerItem)?.cancel()
            removeObserver(item)
        }
    }

    /// 移除观察者
    /// - Parameter object: 观察者
    open func removeObserver(_ object: AnyObject, labelName name: String = "") {
        if var description = object.description {
            if name == "" {
                let keyArray = observers.filter { (key, _) -> Bool in
                    key.hasPrefix(description)
                }
                keyArray.values.forEach { item in
                    (item as? XTITimerItem)?.cancel()
                    removeObserver(item)
                }
            } else {
                description += name
                if let item = self.observers[description] as? XTITimerItem {
                    item.cancel()
                    self.removeObserver(item)
                }
            }
        }
    }
}
