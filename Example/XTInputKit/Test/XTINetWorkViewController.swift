//
//  XTINetWorkViewController.swift
//  XTInputKit
//
//  Created by xt-input on 2018/3/19.
//  Copyright © 2018年 input. All rights reserved.
//

import Alamofire
import UIKit

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickRequestButton(_ sender: UIButton) {
    }

    // MARK: -UITextViewDelegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }

    deinit {
        xtiloger.debug(self)
    }
}
