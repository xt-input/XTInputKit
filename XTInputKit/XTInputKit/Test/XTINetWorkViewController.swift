//
//  XTINetWorkViewController.swift
//  XTInputKit
//
//  Created by Input on 2018/3/19.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

class XTINetWorkViewController: UIViewController, UITextViewDelegate {
    var request: XTITestRequest!

    @IBOutlet var resultTextView: UITextView!
    var resultString: String! {
        didSet {
            resultTextView.text = resultTextView.text + resultString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.xti_navigationTitle = "网络请求"
        XTINetWorkConfig.iSLogRawData = false
        XTINetWorkConfig.defaultHostName = "design.07coding.com" // 设置默认的网络请求域名
        XTINetWorkConfig.defaultSignature = { (parameters) -> String in // 设置所有的接口的签名方法
            loger.debug(parameters)
            return "signature=signature"
        }
        resultTextView.delegate = self
        loger.debug(XTITool.compareAppVersion("2.1.0"))
        loger.debug(XTITool.compareAppVersion("1.12.0"))
        loger.debug(XTITool.compareAppVersion("1.21.1"))
        loger.debug(XTITool.compareAppVersion("1.1.1"))
        loger.debug(XTITool.compareAppVersion("1.1"))
        loger.debug(XTITool.compareAppVersion("1.1.0"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickRequestButton(_ sender: UIButton) {
        request = XTITestRequest()
        request.bundelID = "1234567890"
        request.send(completed: { [weak self] _, result in
            if let res = result as? XTITestResult {
                if let strongSelf = self {
                    strongSelf.resultString = loger.debug(res.toJSONString()!)
                }
            }
        }) { [weak self] _, error in
            if let strongSelf = self {
                strongSelf.resultString = loger.warning(error?.localizedDescription)
            }
        }

        let p1: [String: Any] = ["bundelID": "11111"]
        XTITest1Request.sharedInstance.get(serviceName: "/rxswift/Login/index", parameters: p1, resultClass: XTITestResult.self, completed: { [weak self] _, result in
            if let res = result as? XTITestResult {
                if let strongSelf = self {
                    strongSelf.resultString = loger.debug(res.toJSON()!)
                }
            }
        }) { [weak self] _, error in
            if let strongSelf = self {
                strongSelf.resultString = loger.warning(error?.localizedDescription)
            }
        }

        let p2: [String: Any] = ["bundelID": "22222"]

        XTIBaseRequest.default.get(url: "http://design.07coding.com/rxswift/Login/index", parameters: p2, resultClass: XTITestResult.self, completed: { [weak self] _, result in
            if let res = result as? XTITestResult {
                if let strongSelf = self {
                    strongSelf.resultString = loger.debug(res.toJSON()!)
                }
            }
        }) { [weak self] _, error in
            if let strongSelf = self {
                strongSelf.resultString = loger.warning(error?.localizedDescription)
            }
        }

        let p3: [String: Any] = ["bundelID": "33333"]

        XTIBaseRequest.default.post(url: "http://design.07coding.com/rxswift/Login/index", parameters: p3, resultClass: XTITestResult.self, completed: { [weak self] _, result in
            if let res = result as? XTITestResult {
                if let strongSelf = self {
                    strongSelf.resultString = loger.debug(res.toJSON()!)
                }
            }
        }) { [weak self] _, error in
            if let strongSelf = self {
                strongSelf.resultString = loger.warning(error?.localizedDescription)
            }
        }
    }

    // MARK: -UITextViewDelegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
}
