//
//  XTImage+.swift
//  XTInputKit
//
//  Created by Input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//

import UIKit

extension UIImage: XTIBaseNameNamespace {}

public extension XTITypeWrapperProtocol where WrappedType == UIImage {
    /// 通过颜色和大小获取图片
    ///
    /// - Parameters:
    ///   - color: 图片的颜色
    ///   - size: 图片的大小
    /// - Returns: 生成的图片()
    public static func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        if context != nil {
            context!.setFillColor(color.cgColor)
            context!.fill(rect)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image == nil ? UIImage() : image!
    }

    /// 图片中心拉伸，适用于设置圆角渐变的边框
    ///
    /// - Returns: 生成的图片
    public func stretchImage() -> UIImage {
        let imageSize = wrappedValue.size
        let point = CGPoint(x: imageSize.width / 2, y: imageSize.height / 2)
        return stretchAtPoint(point)
    }

    /// 图片从指定的点拉伸
    ///
    /// - Parameter point: 拉伸的点
    /// - Returns: 生成的图片
    public func stretchAtPoint(_ point: CGPoint) -> UIImage {
        let edgeInsets = UIEdgeInsets(top: point.y, left: point.x, bottom: wrappedValue.size.height - point.y, right: wrappedValue.size.width - point.x)
        return wrappedValue.resizableImage(withCapInsets: edgeInsets, resizingMode: UIImage.ResizingMode.stretch)
    }
}
