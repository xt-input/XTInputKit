//
//  XTITabBar.swift
//  XTInputKitDemo
//
//  Created by xt-input on 2019/5/30.
//  Copyright © 2019 tcoding.cn. All rights reserved.
//

import UIKit
import XTInputKit

class XTITabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = XTIMacros.TABBAR_HEIGHT
        return sizeThatFits
    }
}
