//
//  XTIViewController+.m
//  XTInputKit
//
//  Created by Input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//

#import "XTIViewController+.h"
#import <objc/runtime.h>
#import "XTIColor+.h"

@implementation UIViewController (xtiExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(xti_viewWillAppear:));
        method_exchangeImplementations(originalMethod, swizzledMethod);

        Method originalDidMethod = class_getInstanceMethod(self, @selector(viewDidAppear:));
        Method swizzledDidMethod = class_getInstanceMethod(self, @selector(xti_viewDidAppear:));
        method_exchangeImplementations(originalDidMethod, swizzledDidMethod);

        Method originalDidLoadMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method swizzledDidLoadMethod = class_getInstanceMethod(self, @selector(xti_viewDidLoad));
        method_exchangeImplementations(originalDidLoadMethod, swizzledDidLoadMethod);

        Method viewWillDisappear_originalMethod = class_getInstanceMethod(self, @selector(viewWillDisappear:));
        Method viewWillDisappear_swizzledMethod = class_getInstanceMethod(self, @selector(xti_viewWillDisappear:));
        method_exchangeImplementations(viewWillDisappear_originalMethod, viewWillDisappear_swizzledMethod);
    });
}

- (void)xti_viewDidLoad {
    [self xti_viewDidLoad];
}

- (void)xti_viewWillAppear:(BOOL)animated {
    [self xti_viewWillAppear:animated];
    if (self.willAppearBlock) {
        self.willAppearBlock(self, animated);
    }
}

- (void)xti_viewDidAppear:(BOOL)animated {
    [self xti_viewDidAppear:animated];
    if (self.xti_navigationBarBackgroundColor) {
        self.navigationController.navigationBar.barTintColor = self.xti_navigationBarBackgroundColor;
    }
}

- (void)xti_viewWillDisappear:(BOOL)animated {
    [self xti_viewWillDisappear:animated];
    //    一定要加多线程处理导航栏的显示，不然手势一开始导航栏就显示了，原因是需要系统的viewWillDisappear执行完成之后再设置导航栏。原理是任务的执行顺序，在viewWillDisappear方法里系统做了很多其他的工作，系统的工作做完之后再操作导航栏
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *viewController = self.navigationController.viewControllers.lastObject;
        if (viewController) {
            if (!viewController.xti_navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:NO animated:NO];
            }
        }
    });
}

- (XTIVCWillAppearBlock)willAppearBlock {
    return (XTIVCWillAppearBlock) objc_getAssociatedObject(self, _cmd);
}

- (void)setWillAppearBlock:(XTIVCWillAppearBlock)willAppearBlock {
    objc_setAssociatedObject(self, @selector(willAppearBlock), willAppearBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setXti_navigationBarBackgroundColor:(UIColor *)xti_navigationBarBackgroundColor {
    objc_setAssociatedObject(self, @selector(xti_navigationBarBackgroundColor), xti_navigationBarBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)xti_navigationBarBackgroundColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXti_disabledBackGesture:(BOOL)xti_disabledBackGesture {
    objc_setAssociatedObject(self, @selector(xti_disabledBackGesture), @(xti_disabledBackGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xti_disabledBackGesture {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setXti_navigationBarHidden:(BOOL)xti_navigationBarHidden {
    objc_setAssociatedObject(self, @selector(xti_navigationBarHidden), @(xti_navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xti_navigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)clickBackIsPop {
    return YES;
}

@end

