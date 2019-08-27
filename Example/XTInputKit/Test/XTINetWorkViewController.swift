//
//  XTINetWorkViewController.swift
//  XTInputKit
//
//  Created by xt-input on 2018/3/19.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

class XTINetWorkViewController: UIViewController, UITextViewDelegate {
    var request: XTITestRequest?

    @IBOutlet var resultTextView: UITextView!
    var resultString: String? {
        didSet {
            resultTextView.text = resultTextView.text + (resultString ?? "")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        xti_navigationTitle = "网络请求"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickRequestButton(_ sender: UIButton) {
        let group = DispatchGroup()
        let p2: [String: Any] = ["bundelID": "22222","list":[1,2,3,4,5]]
        group.enter()
        XTITest1Request.shared().get(serviceName: "rxswift/login/index") { value, error in
            xtiloger.debug(value)
            xtiloger.debug(error)
            xtiloger.debug("任务1")
            group.leave()
        }

        group.enter()
        XTITest1Request.shared().post(url: "http://design.tcoding.cn/rxswift/login/index", parameters: p2) { value, error in
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

        XTIModelRequest().get { value, error in
            xtiloger.debug(value)
            xtiloger.debug(error)
        }
    }

    // MARK: -UITextViewDelegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }

    deinit {
        xtiloger.debug(self)
    }
}
