//
//  AppDelegate.swift
//  XTInputKitDemo
//
//  Created by Input on 2018/1/20.
//  Copyright © 2018年 input. All rights reserved.
//

import OpenUDID
import SimulateIDFA
import UIKit
import UserNotifications

var loger = XTILoger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var view: UIView?
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        loger.saveFileLevel = .all
//        loger.debug("应用即将启动")
        // 将广告追加在应用启动后主队列里
        DispatchQueue.XTI.mainAsyncAfter(0) {
            self.test()
        }
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                loger.debug("通知授权")
                loger.debug(granted)
            }
        } else {
            // Fallback on earlier versions
        }
        loger.debug("SimulateIDFA==>" + SimulateIDFA.createSimulateIDFA())
        loger.debug("OpenUDID==>" + OpenUDID.value())
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: XTIMacros.SCREEN_BOUNDS)
//        UINavigationController.xti_openBackGesture = false
        self.initRootViewController()
        loger.debug("应用完成启动前的准备")
        return true
    }

    func initRootViewController() {
        let vc = UITabBarController()
        let navc1 = XTINavigationController(rootViewController: ViewController.initwithstoryboard("Storyboard"))
        vc.xti_addChildViewController(navc1, tabbarTitle: "测试", image: UIImage.XTI.imageWithColor(UIColor.green, size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal), selectedImage: nil)
        let navc2 = XTINavigationController(rootViewController: XTIKeyChainViewController.initwithstoryboard("Storyboard"))
        vc.xti_addChildViewController(navc2, tabbarTitle: "KeyChain", image: UIImage.XTI.imageWithColor(UIColor.red, size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal), selectedImage: nil)

        let navc3 = XTINavigationController(rootViewController: XTINetWorkViewController.initwithstoryboard("Storyboard"))
        vc.xti_addChildViewController(navc3, tabbarTitle: "NetWork", image: UIImage.XTI.imageWithColor(UIColor.red, size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal), selectedImage: nil)
        let navc4 = XTINavigationController(rootViewController: XTIDivViewController())
        vc.xti_addChildViewController(navc4, tabbarTitle: "嵌套", image: UIImage.XTI.imageWithColor(UIColor.red, size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysOriginal), selectedImage: nil)
        
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
        self.test()
    }

    func test() {
        self.view?.removeFromSuperview()
        self.view = UIView(frame: (self.window?.frame)!)
        self.view?.backgroundColor = UIColor.red
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        label.center = (self.view?.center)!
        self.view?.addSubview(label)
        self.window?.addSubview(self.view!)
        label.text = "3"
        XTITimer.defualt.addObserver(self, repeating: 1, sum: 3) { item in
            loger.debug(item?.count)
            label.text = "\(item!.sum - item!.count)"
            if (item?.isEnd())! {
                self.view?.removeFromSuperview()
            }
        }
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

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        loger.debug("收到通知")
        loger.debug(notification.userInfo)
    }
}

