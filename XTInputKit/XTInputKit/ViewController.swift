//
//  ViewController.swift
//  XTInputKitDemo
//
//  Created by Input on 2018/1/20.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

var count = 0

class ViewController: UIViewController {
    private var _testcolor: UIColor!
    var testcolor: UIColor! {
        if _testcolor == nil {
            _testcolor = UIColor.XTI.random
        }
        return _testcolor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.view.backgroundColor = UIColor.XTI.random
        self.view.backgroundColor = UIColor.white

        self.xti_navigationTitle = "navigation标题"
        self.xti_setBarButtonItem(.right, title: "测试")
        self.xti_nextBackTitle = "返回"
        self.xti_nextBackColor = UIColor.XTI.random
        self.xti_tabbarTitle = "tabbar标题"
        if let navigaVC = self.navigationController {
            if navigaVC.viewControllers.count % 2 == 0 {
//                self.xti_navigationBarHidden = true
            }
        }
        self.xti_navigationBarBackgroundColor = self.testcolor
    }

    @objc func xti_toucheRightBarButtonItem() {
        loger.debug("点击了导航栏右边的按钮")
        loger.debug(self.xti_nextBackTitle)
//        XTITool.keyWindow.rootViewController = ViewController.initwithstoryboard("Storyboard")
//        let s = UISlider()或者用UISlider也可以实现
//        s.
    }

    @IBAction func clickPushBtn(_ sender: UIButton) {
//        self.navigationController?.pushViewController(ViewController.initwithstoryboard("Storyboard"), animated: false)
        self.xti_pushOrPresentVC(ViewController.initwithstoryboard("Storyboard"))
        count += 1
    }

    @IBAction func clickDismissBtn(_ sender: UIButton) {
        self.xti_popOrDismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        count -= 1
    }
}
