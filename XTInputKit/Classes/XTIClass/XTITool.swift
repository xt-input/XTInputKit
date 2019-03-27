//
//  XTITool.swift
//  XTInputKitDemo
//
//  Created by Input on 2018/1/29.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

public enum XTIVersionCompareResult {
    case equal // 等于当前版本
    case greater // 大于当前版本
    case less // 小于当前版本
}

open class XTITool {
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
        if keyWindow?.windowLevel == UIWindow.Level.normal {
            UIApplication.shared.windows.forEach { window in
                if window.windowLevel == UIWindow.Level.normal {
                    keyWindow = window
                }
            }
        }
        return keyWindow
    }

    /// 版本号比较，一般的项目版本号用float类型不能满足要求，而字符串直接比较当版本号某一块大于9的时候就不能直接用字符串比较
    ///
    /// - Parameter version: 需要比较的版本号，用"."分割版本号 1.12.3 > 1.2.3
    /// - Returns: 比较结果
    public static func compareAppVersion(_ version: String) -> XTIVersionCompareResult {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if appVersion == version {
                return .equal
            }

            var versions = version.components(separatedBy: ".")
            var appVersions = appVersion.components(separatedBy: ".")
            let count = max(appVersions.count, versions.count)
            for _ in 0 ..< count {
                if versions.count < count {
                    versions.append("0")
                }
                if appVersions.count < count {
                    appVersions.append("0")
                }
            }

            for i in 0 ..< count {
                if versions[i] < appVersions[i] {
                    return .less
                }
                if versions[i] > appVersions[i] {
                    return .greater
                }
            }
        }
        return .equal
    }
}
