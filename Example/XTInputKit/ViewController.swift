//
//  ViewController.swift
//  XTInputKit
//
//  Created by xt-input on 2018/1/20.
//  Copyright © 2018年 input. All rights reserved.
//

import Alamofire
import Kingfisher
import UIKit

var count = 0

// enum T1 {
//    enum T2 {
//        case str
//    }
// }

// struct T: Mappable {
//    var string: String?
//    var int: Int?
//    var double: Double?
//    var float: Float?
//    var bool: Bool?
//    init?(map: Map) {}
//    mutating func mapping(map: Map) {
//        string <- map["string"]
//        int <- map["int"]
//        double <- map["double"]
//        float <- map["float"]
//        bool <- map["bool"]
//        print(map["double"].value() ?? "123")
//    }
// }

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        xtiloger.info(String(format: NSLocalizedString("密码错误，还有%d次", comment: ""), 123))

        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        self.xti_navigationTitle = "navigation标题"
        self.xti_setBarButtonItem(.right, title: "测试")
        self.xti_nextBackTitle = ""
        self.xti_nextBackColor = UIColor.xti.hex("0x00ffff44")
        self.xti_tabbarTitle = "tabbar标题"

        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: ""), placeholder: UIImage())
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

    @IBAction func clickTabBtn(_ sender: UIButton) {
//        self.xti_pushOrPresentVC(TableViewController.initwithstoryboard("Storyboard"))
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
            notification.subtitle = "通知上显示的提示内容"

            // 收到通知时播放的声音，默认消息声音
            notification.sound = UNNotificationSound.default
            // 通知上绑定的其他信息，为键值对
            notification.userInfo = ["id": "1", "name": "xxxx"]
            notification.title = "测试"
            notification.categoryIdentifier = "UNNotificationRequestUNNotificationRequest"
            xtiloger.debug("发送通知")
            //        UIApplication.shared.presentLocalNotificationNow(notification)
            let request = UNNotificationRequest(identifier: "UNNotificationRequestUNNotificationRequest", content: notification, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false))
            UNUserNotificationCenter.current().add(request) { error in
                xtiloger.debug(error)
            }
        } else {
            // Fallback on earlier versions
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        XTILoger.shared().info(String(reflecting: T1.T2.str))
//        XTITimer.defualt.removeObserver(self)
//        let labelName: Int = Int(arc4random())
//        XTITimer.defualt.addObserver(self, labelName: "\(labelName)", repeating: 1.0, sum: labelName) { _ in
//            if item?.count == 12 {
//                item?.isCancel = true
//            }
//            xtiloger.debug(item?.count)
//        }

        let group = DispatchGroup()
        
        var map = XTITestModel()
        let p2: [String: Any] = ["bundelID": "22222", "map": map.toJsonString() ?? ""]

        group.enter()
        XTITest1Request.shared().get(serviceName: "rxswift/login/index", cache: { value in
            xtiloger.debug("----------\(String(describing: value))")
        }) { value, error in
            xtiloger.debug(value)
            xtiloger.debug(error)
            xtiloger.debug("任务1")
            group.leave()
        }

        group.enter()
        XTITest1Request.shared().get(url: "http://design.tcoding.cn/rxswift/login/index", parameters: p2) { value, error in
            xtiloger.debug(value)
            xtiloger.debug(error)
            xtiloger.debug("任务2")
            group.leave()
        }

        group.enter()
        XTITest1Request.shared().get(serviceName: "rxswift/login/index", success: { value in
            xtiloger.debug(value)
            xtiloger.debug("任务3")
            group.leave()
        })

        group.enter()
        XTITest1Request.shared().get(serviceName: "rxswift/login/index", success: { value in
            xtiloger.debug(value)
            xtiloger.debug("任务4")
            group.leave()
        }, error: { error in
            xtiloger.debug(error)
            xtiloger.debug("任务4")
            group.leave()
        })

        group.notify(queue: DispatchQueue.main) {
            xtiloger.debug("任务完成")
        }

        XTIModelRequest.shared().get { value, error in
            xtiloger.debug(value)
            xtiloger.debug(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        count -= 1
        xtiloger.debug(count)
    }
}
