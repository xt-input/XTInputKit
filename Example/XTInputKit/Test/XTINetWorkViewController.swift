//
//  XTINetWorkViewController.swift
//  XTInputKit
//
//  Created by Input on 2018/3/19.
//  Copyright © 2018年 input. All rights reserved.
//

import Alamofire
import HandyJSON
import UIKit
import XTInputKit

class XTINetWorkViewController: UIViewController, UITextViewDelegate {
    var request: XTITestRequest?

    @IBOutlet var resultTextView: UITextView!
    var resultString: String! {
        didSet {
            resultTextView.text = resultTextView.text + resultString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        xti_navigationTitle = "网络请求"
        XTINetWorkConfig.iSLogRawData = false
        XTINetWorkConfig.defaultHostName = "design.tcoding.cn" // 设置默认的网络请求域名
        XTINetWorkConfig.defaultHttpScheme = .http
        XTINetWorkConfig.defaultSignature = { (parameters) -> String in // 设置所有的接口的签名方法
            xtiloger.debug(parameters)
            return "signature=signature"
        }
        resultTextView.delegate = self
//        xtiloger.debug(XTITool.compareAppVersion("2.1.0"))
//        xtiloger.debug(XTITool.compareAppVersion("1.12.0"))
//        xtiloger.debug(XTITool.compareAppVersion("1.21.1"))
//        xtiloger.debug(XTITool.compareAppVersion("1.1.1"))
//        xtiloger.debug(XTITool.compareAppVersion("1.1"))
//        xtiloger.debug(XTITool.compareAppVersion("1.1.0"))
        resultTextView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        xtiloger.debug(keyPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickRequestButton(_ sender: UIButton) {
        request = XTITestRequest()
        request?.bundelID = "1234567890"
//        DispatchQueue.XTI.mainAsyncAfter(3) {
//            self.request.send(success: {[weak self] _, result in
//                self?.resultString = xtiloger.debug(result)
//                if let res = result as? XTITestResult {
//                    self?.resultString = xtiloger.debug(res.toJSON()!)
//                }
//            }) { [weak self] _, error in
//                if let strongSelf = self {
//                    strongSelf.resultString = xtiloger.warning(error?.localizedDescription)
//                }
//            }
//            self.request.send(success: {[weak self] _, result in
//                if let res = result as? HandyJSON {
//                    self?.resultString = xtiloger.debug(res.toJSON()!)
//                }
//            }) { [weak self] _, error in
//                if let strongSelf = self {
//                    strongSelf.resultString = xtiloger.warning(error?.localizedDescription)
//                }
//            }
//            self.request.send(success: {[weak self] _, result in
//                if let res = result as? XTITestResult {
//                    self?.resultString = xtiloger.debug(res.toJSONString()!)
//                }
//            }) { [weak self] _, error in
//                if let strongSelf = self {
//                    strongSelf.resultString = xtiloger.warning(error?.localizedDescription)
//                }
//            }
//            self.request.send(success: {[weak self] _, result in
//                if let res = result as? XTITestResult {
//                    self?.resultString = xtiloger.debug(res.toJSON()!)
//                }
//            }) { [weak self] _, error in
//                if let strongSelf = self {
//                    strongSelf.resultString = xtiloger.warning(error?.localizedDescription)
//                }
//            }
//        }
//
//        self.request?.send(completed:{ [weak self] _, result, error in
//            if let res = result as? XTITestResult {
//                if let strongSelf = self {
//                    strongSelf.resultString = xtiloger.debug(res.toJSONString())
//                }
//            } else {
//                if let strongSelf = self {
//                    strongSelf.resultString = xtiloger.warning(error.debugDescription)
//                }
//            }
//        })
//
//        self.request = nil

        let p2: [String: Any] = ["bundel": "22222"]
        XTITest1Request.shared.get(url: "http://design.tcoding.cn/rxswift/login/index", parameters: p2, resultClass: XTITestResult.self, completed: { [weak self] _, result, error in
            if let res = result as? XTITestResult {
                if let strongSelf = self {
                    strongSelf.resultString = xtiloger.debug(res.toJSON()!)
                }
            } else {
                if let strongSelf = self {
                    strongSelf.resultString = xtiloger.warning(error.debugDescription)
                }
            }
        })

        XTITest1Request.shared.get(url: "http://design.tcoding.cn/131231/12312/123123", parameters: p2, resultClass: XTITestResult.self, completed: { [weak self] _, result, error in
            if error == nil, let res = result as? XTITestResult {
                if let strongSelf = self {
                    strongSelf.resultString = xtiloger.debug(res.toJSONString())
                }
            } else {
                if let strongSelf = self {
                    strongSelf.resultString = xtiloger.warning(error.debugDescription)
                }
            }
        })
    }

    // MARK: -UITextViewDelegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }

    deinit {
        xtiloger.debug(self)
    }
}
