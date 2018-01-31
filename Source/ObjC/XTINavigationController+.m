//
//  XTINavigationController+.m
//  XTInputKit
//
//  Created by Input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//

#import "XTINavigationController+.h"
#import <objc/runtime.h>

@interface XTIGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation XTIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    UIViewController *topViewController = [self.navigationController topViewController];
    if (topViewController.xti_disabledBackGesture ||
        self.navigationController.viewControllers.count <= 1 ||
        [[self.navigationController valueForKey:@"isTransitioning"] boolValue]) {
        return NO;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    return YES;
}

@end

@interface UINavigationController()

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *xti_PanGesture;
@end

@implementation UINavigationController(xtiExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalPushMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
        Method swizzledPushMethod = class_getInstanceMethod(self, @selector(xti_objc_pushViewController:animated:));
        method_exchangeImplementations(originalPushMethod, swizzledPushMethod);
    });
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }

    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    shouldPop = [vc clickBackIsPop];
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

- (void)xti_objc_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = self.xti_hiddenTabbarIfNonRootViewController;
    }
    if (self.xti_openBackGesture) {
        if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.xti_PanGesture]) {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.xti_PanGesture];
            NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
            id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
            self.xti_PanGesture.delegate = self.popGestureDelegate;
            [self.xti_PanGesture addTarget:internalTarget action:internalAction];
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    [self setupViewControllerNavigationBar:viewController];
    if (![self.viewControllers containsObject:viewController]) {
        [self xti_objc_pushViewController:viewController animated:animated];
    }
}
- (UIPanGestureRecognizer *)xti_PanGesture {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (void)setupViewControllerNavigationBar:(UIViewController *)viewController {
    __weak typeof(self) weakSelf = self;
    XTIVCWillAppearBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.xti_navigationBarHidden animated:animated];
        }
    };
    viewController.willAppearBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.willAppearBlock) {
        disappearingViewController.willAppearBlock = block;
    }
}

- (XTIGestureRecognizerDelegate *)popGestureDelegate {
    XTIGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[XTIGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (void)setXti_openBackGesture:(BOOL)xti_openBackGesture {
    objc_setAssociatedObject(self, @selector(xti_openBackGesture), @(xti_openBackGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xti_openBackGesture {
    NSNumber *openBackGesture = objc_getAssociatedObject(self, _cmd) ;
    if (openBackGesture){
        return [openBackGesture boolValue];
    }
    self.xti_openBackGesture = UINavigationController.xti_openBackGesture;
    return YES;
}

+ (void)setXti_openBackGesture:(BOOL)xti_openBackGesture {
    objc_setAssociatedObject(self, @selector(xti_openBackGesture), @(xti_openBackGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)xti_openBackGesture {
    NSNumber *openBackGesture = objc_getAssociatedObject(self, _cmd) ;
    if (openBackGesture){
        return [openBackGesture boolValue];
    }
    self.xti_openBackGesture = YES;
    return YES;
}

- (void)setXti_hiddenTabbarIfNonRootViewController:(BOOL)xti_hiddenTabbarIfNonRootViewController {
    objc_setAssociatedObject(self, _cmd, @(xti_hiddenTabbarIfNonRootViewController), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xti_hiddenTabbarIfNonRootViewController {
    NSNumber *hiddenTabbar = objc_getAssociatedObject(self, _cmd);
    if (hiddenTabbar){
        return [hiddenTabbar boolValue];
    }
    self.xti_hiddenTabbarIfNonRootViewController = YES;
    return YES;
}

@end

