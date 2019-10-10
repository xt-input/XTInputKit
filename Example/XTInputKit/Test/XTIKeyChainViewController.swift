//
//  XTIKeyChainViewController.swift
//  XTInputKit
//
//  Created by xt-input on 2018/3/18.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

class XTIKeyChainViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var keyTextField: UITextField!
    @IBOutlet var valueTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.xti_navigationTitle = "KeyChain"
        let keyLabel = UILabel()
        keyLabel.text = " 键："
        self.keyTextField.leftView = keyLabel
        self.keyTextField.leftViewMode = .always
        self.keyTextField.delegate = self
        let valueLabel = UILabel()
        valueLabel.text = " 值："
        self.valueTextField.leftView = valueLabel
        self.valueTextField.leftViewMode = .always
        xtiloger.debug(XTIKeyChainTool.shared().keyChainUuid)
    }

    @IBAction func clickSaveButton(_ sender: UIButton) {
        let value = self.valueTextField.text!
        let key = self.keyTextField.text!
        XTIKeyChainTool.shared().set(value, forKey: key)
    }

    @IBAction func clickReadButton(_ sender: UIButton) {
        let key = self.keyTextField.text!
        if let value = XTIKeyChainTool.shared().get(valueTpye: String.self, forKey: key) {
            self.valueTextField.text = value
        } else {
            self.showMessage(title: "提示", message: "该键值不存在")
        }
    }

    @IBAction func clickDeleteButton(_ sender: UIButton) {
        let key = self.keyTextField.text!
        if XTIKeyChainTool.shared().delete(key) {
            self.showMessage(message: "删除成功！")
        } else {
            self.showMessage(message: "删除失败！")
        }
    }

    @IBAction func clickDeleteAllButton(_ sender: UIButton) {
        if XTIKeyChainTool.shared().delete() {
            self.showMessage(message: "删除成功！")
        } else {
            self.showMessage(message: "删除失败！")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
