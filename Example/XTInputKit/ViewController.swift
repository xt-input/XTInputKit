//
//  ViewController.swift
//  XTInputKit
//
//  Created by Input on 2018/1/20.
//  Copyright © 2018年 input. All rights reserved.
//

// import Alamofire
import UIKit
import UserNotifications
import WebKit
import XTInputKit

var count = 0

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var _testcolor: UIColor!

    var testcolor: UIColor! {
        if self._testcolor == nil {
            self._testcolor = UIColor.XTI.random
        }
        return self._testcolor
    }

    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let s = "123123123"

        print(String(format: "%p", s))
        xtiloger.debug(format: "%p   %p", s, s)
        xtiloger.debug(String(format: "%p", s))

        print(String(format: "%p", self))
        xtiloger.debug(format: "%p   %p", self, nil)
        xtiloger.debug(String(format: "%p", self))

        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        self.xti_navigationTitle = "navigation标题"
        self.xti_setBarButtonItem(.right, title: "测试")
        self.xti_nextBackTitle = ""
        self.xti_nextBackColor = UIColor.XTI.random
        self.xti_tabbarTitle = "tabbar标题"
        XTITimer.defualt.addObserver(self, repeating: 1, sum: 20)
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UITableViewCell.className)
        self.tableView.addObserver(self, forKeyPath: "tableView", options: .new, context: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//                XTIObserverTest.default.removeObserver(self)
    }

    @objc func xti_toucheRightBarButtonItem() {
        //        xtiloger.debug("点击了导航栏右边的按钮")
        //        xtiloger.debug(self.xti_nextBackTitle)
//        self.xti_pushOrPresentVC(XTINetWorkViewController.initwithstoryboard("Storyboard"))
    }

    @objc func countdown(_ item: XTITimerItem) {
        xtiloger.debug(item.count)
        if item.count == 12 {
            item.isCancel = true
        }
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    }

    @IBAction func clickPushBtn(_ sender: UIButton) {
        //        self.navigationController?.pushViewController(ViewController.initwithstoryboard("Storyboard"), animated: false)
        self.xti_pushOrPresentVC(ViewController.initwithstoryboard("Storyboard"))
        count += 1
    }

    @IBAction func clickDismissBtn(_ sender: UIButton) {
        self.xti_popOrDismiss()
    }

    @IBAction func clickNotificationBtn(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            let notification = UNMutableNotificationContent()
            // 通知上显示的主题内容
            notification.body = "通知上显示的提示内容"
            notification.subtitle = "通知上显示的提示内容1"

            // 收到通知时播放的声音，默认消息声音
            notification.sound = UNNotificationSound.default
            // 通知上绑定的其他信息，为键值对
            notification.userInfo = ["id": "1", "name": "xxxx"]
            notification.title = "测试"
            notification.categoryIdentifier = "UNNotificationRequestUNNotificationRequest"
            xtiloger.debug("发送通知")
            //        UIApplication.shared.presentLocalNotificationNow(notification)
            let request = UNNotificationRequest(identifier: "UNNotificationRequestUNNotificationRequest", content: notification, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
            UNUserNotificationCenter.current().add(request) { error in
                xtiloger.debug(error)
            }
        } else {
            // Fallback on earlier versions
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        XTITimer.defualt.removeObserver(self)
        let labelName: Int = Int(arc4random())
        XTITimer.defualt.addObserver(self, labelName: "\(labelName)", repeating: 1.0, sum: labelName) { _ in
//            if item?.count == 12 {
//                item?.isCancel = true
//            }
//            xtiloger.debug(item?.count)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        count -= 1
        xtiloger.debug(count)
        self.tableView.removeObserver(self, forKeyPath: "tableView")
    }
}
