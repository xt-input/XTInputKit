//
//  UITabBarController+.swift
//  XTInputKit
//
//  Created by Input on 2018/1/27.
//  Copyright © 2018年 input. All rights reserved.
//

import UIKit

public extension UITabBarController {
    
    /// 添加tabbar的子控制器
    ///
    /// - Parameters:
    ///   - viewController: 控制器
    ///   - tabbarTitle: tabbar标题
    ///   - image: 默认图片
    ///   - selectedImage: 选中图片
    public func xti_addChildViewController(_ viewController: UIViewController,
                                           tabbarTitle: String! = nil,
                                           image: UIImage,
                                           selectedImage: UIImage! = nil) {
        if tabbarTitle != nil {
            viewController.xti_tabbarTitle = tabbarTitle
        }
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage == nil ? image : selectedImage
    	self.addChildViewController(viewController)
    }
    
}
