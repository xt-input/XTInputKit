//
//  XTIView+.swift
//  XTInputKit
//
//  Created by xt-input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//

import UIKit
extension UIView: XTIBaseNameNamespace {}

public extension XTITypeWrapperProtocol where WrappedType == UIView {
    /// 将View转换成img
    ///
    /// - Returns: 转换的结果
    func xt_convertViewToImage() -> UIImage! {
        let scale = UIScreen.main.scale
        let size = __CGSizeApplyAffineTransform(wrappedValue.bounds.size, CGAffineTransform(scaleX: scale, y: scale))
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        wrappedValue.drawHierarchy(in: CGRect(origin: CGPoint.zero, size: size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}

// layer
public extension UIView {
    /// 边框宽度
    @IBInspectable var xt_borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }

    /// 边框颜色
    @IBInspectable var xt_borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return self.layer.borderColor == nil ? UIColor.clear : UIColor(cgColor: self.layer.borderColor!)
        }
    }

    /// 设置圆角
    @IBInspectable var xt_cornerRadius: CGFloat {
        set {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
}
