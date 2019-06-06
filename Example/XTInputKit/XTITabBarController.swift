//
//  XTITabBarController.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2019/5/30.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import UIKit
import XTInputKit

class XTITabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        object_setClass(self.tabBar, XTITabBar.classForCoder())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard #available(iOS 11, *) else {
            var frame = self.tabBar.frame
            frame.origin.y = XTIMacros.SCREEN_HEIGHT - frame.size.height
            self.tabBar.frame = frame
            return
        }
    }
}
