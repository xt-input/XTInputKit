//
//  AppDelegate.swift
//  XTInputKit
//
//  Created by Input on 2018/1/20.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit
import UserNotifications
import XTInputKit

var loger = XTILoger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        //        loger.saveFileLevel = .all
        //        loger.debug("应用即将启动")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            loger.debug("通知授权")
            loger.debug(granted)
        }
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: XTIMacros.SCREEN_BOUNDS)
        //        UINavigationController.xti_openBackGesture = false
        loger.debug(UIDevice().xti.modelName.rawValue)
        loger.debug(XTIMacros.isIphone)
        self.initRootViewController()
        loger.debug("应用完成启动前的准备")
        return true
    }

    func initRootViewController() {
        let vc = UITabBarController()
        let navc1 = XTINavigationController(rootViewController: ViewController.initwithstoryboard("Storyboard"))
        vc.xti.addChildViewController(navc1, tabbarTitle: "测试", image: UIImage.XTI.imageWithColor(UIColor.green, size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal), selectedImage: nil)
        let navc2 = XTINavigationController(rootViewController: XTIKeyChainViewController.initwithstoryboard("Storyboard"))
        vc.xti.addChildViewController(navc2, tabbarTitle: "KeyChain", image: UIImage.XTI.imageWithColor(UIColor.red, size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal), selectedImage: nil)

        let navc3 = XTINavigationController(rootViewController: XTINetWorkViewController.initwithstoryboard("Storyboard"))
        vc.xti.addChildViewController(navc3, tabbarTitle: "NetWork", image: UIImage.XTI.imageWithColor(UIColor.red, size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal), selectedImage: nil)

        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        loger.debug("应用即将退到后台")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        loger.debug("应用已经退到后台")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        loger.debug("应用即将回到前台<成为第一响应者>")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        loger.debug("应用变成活跃状态<可以是后台回到前台，也可以是启动>")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        loger.debug("应用即将被杀死")
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        loger.debug("收到通知")
        loger.debug(notification.description)
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        loger.debug("点击通知")
        loger.debug(response.description)
        completionHandler()
    }
}
