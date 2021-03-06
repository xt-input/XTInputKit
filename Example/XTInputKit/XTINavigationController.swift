//
//  XTINavigationController.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2018/1/29.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

var i = 0

class XTINavigationController: UINavigationController {
    var j: Int! = i

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        i += 1
        let img = UIImage.xti.imageWithColor(UIColor(red: 0.8, green: 0.3, blue: 0.4, alpha: 0.1), size: CGSize(width: XTIMacros.SCREEN_WIDTH, height: 64))
        self.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !self.viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

