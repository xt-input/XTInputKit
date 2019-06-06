//
//  XTIMacros.swift
//  XTInputKit
//
//  Created by xt-input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//

import UIKit

public struct XTIMacros {
    //  MARK: - 界面绘制常用的尺寸数据快捷获取

    public static var SCREEN_BOUNDS: CGRect {
        return UIScreen.main.bounds
    }

    public static var SCREEN_SIZE: CGSize {
        return UIScreen.main.bounds.size
    }

    public static var SCREEN_WIDTH: CGFloat {
        return SCREEN_SIZE.width
    }

    public static var SCREEN_HEIGHT: CGFloat {
        return SCREEN_SIZE.height
    }

    //  MARK: - 判断屏幕

    public static var isIphone5: Bool {
        return SCREEN_SIZE.equalTo(CGSize(width: 320, height: 568)) || SCREEN_SIZE.equalTo(CGSize(width: 568, height: 320))
    }

    public static var isIphone: Bool {
        return SCREEN_SIZE.equalTo(CGSize(width: 375, height: 667)) || SCREEN_SIZE.equalTo(CGSize(width: 667, height: 375))
    }

    public static var isIphonePuls: Bool {
        return SCREEN_SIZE.equalTo(CGSize(width: 414, height: 736)) || SCREEN_SIZE.equalTo(CGSize(width: 736, height: 414))
    }

    public static var isIphoneX: Bool {
        return SCREEN_SIZE.equalTo(CGSize(width: 375, height: 812)) || SCREEN_SIZE.equalTo(CGSize(width: 812, height: 375)) || SCREEN_SIZE.equalTo(CGSize(width: 896, height: 414)) || SCREEN_SIZE.equalTo(CGSize(width: 414, height: 896))
    }

    public static var BUTTON_HEIGHT: CGFloat {
        return isIphoneX ? 34.0 : 0.0
    }

    public static var TABBAR_HEIGHT: CGFloat {
        return isIphoneX ? 83.0 : 49.0
    }

    public static var NAVBAR_HEIGHT: CGFloat {
        return isIphoneX ? 88.0 : 64.0
    }
}
