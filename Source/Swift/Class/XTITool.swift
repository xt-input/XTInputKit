//
//  XTITool.swift
//  XTInputKitDemo
//
//  Created by Input on 2018/1/29.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

public class XTITool {
    /// 获取当前活动的控制器(忽略tabbar和navigaction)
    public static var currentVC: UIViewController! {
        var current: UIViewController! = keyWindow.rootViewController
        while current.isKind(of: UITabBarController.self) || current.isKind(of: UINavigationController.self) {
            if let tab = current as? UITabBarController {
                current = tab.selectedViewController
            }
            if let nav = current as? UINavigationController {
                current = nav.topViewController
            }
        }
        while current.presentedViewController != nil {
            current = current.presentedViewController
        }
        return current
    }

    /// 获取rootVC
    public static var rootVC: UIViewController! {
        return keyWindow.rootViewController
    }

    /// 获取当前应用活动的窗口
    public static var keyWindow: UIWindow! {
        var keyWindow = UIApplication.shared.keyWindow
        if keyWindow?.windowLevel == UIWindowLevelNormal {
            UIApplication.shared.windows.forEach { window in
                if window.windowLevel == UIWindowLevelNormal {
                    keyWindow = window
                }
            }
        }
        return keyWindow
    }
}
