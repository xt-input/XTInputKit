//
//  XTINavigationController+.h
//  XTInputKit
//
//  Created by Input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//	参考：https://github.com/forkingdog/FDFullscreenPopGesture

#import "XTIViewController+.h"

/**
 右划动作结束后的位移量的通知，userInfo参数：@{@"moveX":@(moveX)}
 */
#define XTINotificationNameNavigationTransitionMoveX @"XTINotificationNameNavigationTransitionMoveX"

@interface UINavigationController (xtExtension)

/**
 是否开启全屏右划返回手势，默认取类属性xti_openBackGesture
 */
- (BOOL)xti_openBackGesture;
/**
 是否开启全屏右划返回手势，默认开启，优先级低于对象属性的xti_openBackGesture
 需要在整个应用第一个UINavigationController兑现初始化之前设置
 */
@property (class, nonatomic, assign) BOOL xti_openBackGesture;
/**
 是否在不是nav的根控制器上隐藏tabbar，默认隐藏YES
 */
@property (nonatomic, assign) BOOL xti_hiddenTabbarIfNonRootViewController;
@end

