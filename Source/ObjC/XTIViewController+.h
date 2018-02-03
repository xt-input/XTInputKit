//
//  XTIViewController+.h
//  XTInputKit
//
//  Created by Input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//	参考：https://github.com/forkingdog/FDFullscreenPopGesture

#import <UIKit/UIKit.h>

typedef void (^XTIVCWillAppearBlock) (UIViewController *viewController, BOOL animated);

@interface UIViewController (xtiExtension)

@property (nonatomic, copy) XTIVCWillAppearBlock willAppearBlock;

/**
 导航栏颜色，不支持透明通道
 */
@property (nonatomic, copy) UIColor *xti_navigationBarBackgroundColor;

/**
 隐藏导航栏，默认为NO
 */
@property (nonatomic, assign) BOOL xti_navigationBarHidden;
//- (void)setXti_navigationBarHidden:(BOOL)xti_navigationBarHidden;
//- (BOOL)xti_navigationBarHidden;
/**
 禁止手势返回，默认为NO
 */
@property (nonatomic, assign) BOOL xti_disabledBackGesture;
//- (void)setXti_disabledBackGesture:(BOOL)xti_disabledBackGesture;
//- (BOOL)xti_disabledBackGesture;

/**
 用于系统导航控制器自带的返回按钮点击是否响应(不拦截手势)
 如果需要拦截手势请禁用右划返回
 */
- (BOOL)clickBackIsPop;

@end

