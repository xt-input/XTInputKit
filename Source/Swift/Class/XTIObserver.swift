//
//  XTObserver.swift
//  XTInputKit
//
//  Created by Input on 2017/4/27.
//  Copyright © 2017年 xt-hacker.com. All rights reserved.
//

import Foundation

public class XTObserver: NSObject {

    @objc public var Observers = [NSObjectProtocol]()
    
    /// 添加观察者
    ///
    /// - Parameter Object: 需要添加的对象
    @objc public func addObserver(Object: NSObjectProtocol?) {
        weak var wkObject = Object
        if wkObject != nil{
            if Observers.contains(where: { (prot) -> Bool in
                prot.description == wkObject!.description
            }){
                return
            }
            Observers.append(wkObject!)
        }
    }
    /// 移除观察者
    ///
    /// - Parameter Object: 需要移除的对象
    @objc public func removeObserver(Object: NSObjectProtocol?) {
        weak var wkObject = Object
        if wkObject != nil{
            for i in 0 ..< Observers.count {
                let de =  Observers[i]
                if de.description == wkObject!.description {
                    Observers.remove(at: i)
                }
            }
        }
    }
	/// 移除所有观察者
    @objc public func removeAllObserver() {
        Observers.removeAll()
    }
}
