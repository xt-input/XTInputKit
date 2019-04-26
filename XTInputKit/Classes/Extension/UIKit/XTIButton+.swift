//
//  XTIButton+.swift
//  XTInputKit
//
//  Created by Input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//

import UIKit
extension UIButton: XTIBaseNameNamespace {}

// font
public extension XTITypeWrapperProtocol where WrappedType == UIButton {
    /// 设置按钮字体
    func titleFont(_ font: UIFont) {
        wrappedValue.titleLabel?.font = font
    }
}
