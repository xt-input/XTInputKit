//
//  XTINavigationController+.m
//  XTInputKit
//
//  Created by Input on 2018/1/19.
//  Copyright © 2018年 Input. All rights reserved.
//

#import "XTINavigationController+.h"
#import <objc/runtime.h>
#import "XTIColor+.h"

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
    CGFloat multiplier = isLeftToRight ? 1 : -1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    return YES;
}
@end

@interface XTINavigationControllerDelegate : NSObject <UINavigationControllerDelegate>
@property (nonatomic, weak) id<UINavigationControllerDelegate> delegate;
@end

@implementation XTINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (!viewController.xti_navigationBarHidden) {
        navigationController.navigationBar.barTintColor = viewController.xti_navigationBarBackgroundColor;
    }
    [self.delegate navigationController:navigationController willShowViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.delegate navigationController:navigationController didShowViewController:viewController animated:animated];
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0)__TVOS_PROHIBITED {
    return [self.delegate navigationControllerSupportedInterfaceOrientations:navigationController];
}
- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0)__TVOS_PROHIBITED {
    return [self.delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
}

- (nullable id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                  interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController NS_AVAILABLE_IOS(7_0) {
    return [self.delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
}

- (nullable id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                           animationControllerForOperation:(UINavigationControllerOperation)operation
                                                        fromViewController:(UIViewController *)fromVC
                                                          toViewController:(UIViewController *)toVC NS_AVAILABLE_IOS(7_0) {
    return [self.delegate navigationController:navigationController
               animationControllerForOperation:operation
                            fromViewController:fromVC
                              toViewController:toVC];
}

@end

@interface UINavigationController ()

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *xti_PanGesture;
@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, strong) UIViewController *popViewController;
@property (nonatomic, strong) XTINavigationControllerDelegate *xtiDelegate;

@end

@implementation UINavigationController (xtiExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalPushMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
        Method swizzledPushMethod = class_getInstanceMethod(self, @selector(xti_objc_pushViewController:animated:));
        method_exchangeImplementations(originalPushMethod, swizzledPushMethod);

        Method originalPopMethod = class_getInstanceMethod(self, @selector(popViewControllerAnimated:));
        Method swizzledPopMethod = class_getInstanceMethod(self, @selector(xti_objc_popViewControllerAnimated:));
        method_exchangeImplementations(originalPopMethod, swizzledPopMethod);
    });
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if ([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }

    BOOL shouldPop = YES;
    UIViewController *vc = [self topViewController];
    shouldPop = [vc clickBackIsPop];
    if (shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for (UIView *subview in [navigationBar subviews]) {
            if (0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25
                                 animations:^{
                                     subview.alpha = 1.;
                                 }];
            }
        }
    }
    return NO;
}

- (UIViewController *)xti_objc_popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [self xti_objc_popViewControllerAnimated:animated];
    CGFloat duration = 0.001;
    if (animated) {
        duration = 0.2;
    }
    if (!self.topViewController.xti_navigationBarHidden) {
        [UIView animateWithDuration:duration
                         animations:^{
                             self.navigationBar.barTintColor = self.topViewController.xti_navigationBarBackgroundColor;
                         }];
    }
    return vc;
}

- (void)xti_objc_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = self.xti_hiddenTabbarIfNonRootViewController;
    }
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    if (self.xti_openBackGesture) {
        if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.xti_PanGesture]) {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.xti_PanGesture];
            self.xti_PanGesture.delegate = self.popGestureDelegate;
            [self.xti_PanGesture addTarget:self action:internalAction];
            [self.xti_PanGesture addTarget:internalTarget action:internalAction];
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    } else if (![[internalTargets.lastObject valueForKey:@"target"] isEqual:self]) {
        [self.interactivePopGestureRecognizer addTarget:self action:internalAction];
    }
    self.delegate = self.xtiDelegate;
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

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)panGesture {
    CGFloat pointX = [panGesture locationInView:self.view].x;
    CGFloat moveX = pointX - self.startX;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.startX = pointX;
            self.popViewController = self.topViewController;
        } break;
        case UIGestureRecognizerStateChanged: {
            UIColor *color;
            if (moveX >= 0) {
                color = [self.topViewController.xti_navigationBarBackgroundColor toColor:self.popViewController.xti_navigationBarBackgroundColor progress:moveX / self.view.bounds.size.width];
            } else {
                color = [self.popViewController.xti_navigationBarBackgroundColor toColor:self.topViewController.xti_navigationBarBackgroundColor progress:moveX / self.view.bounds.size.width];
            }
            if (!self.topViewController.xti_navigationBarHidden && !self.popViewController.xti_navigationBarHidden) {
                self.navigationBar.barTintColor = color;
            }
        } break;
        default:
            [NSNotificationCenter.defaultCenter postNotificationName:XTINotificationNameNavigationTransitionMoveX object:nil userInfo:@{ @"moveX": @(moveX) }];
            break;
    }
}

- (void)setXtiDelegate:(XTINavigationControllerDelegate *)xtiDelegate {
    objc_setAssociatedObject(self, @selector(xtiDelegate), xtiDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (XTINavigationControllerDelegate *)xtiDelegate {
    XTINavigationControllerDelegate *xtiDelegate = objc_getAssociatedObject(self, _cmd);
    if (!xtiDelegate) {
        xtiDelegate = [[XTINavigationControllerDelegate alloc] init];
        objc_setAssociatedObject(self, _cmd, xtiDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return xtiDelegate;
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    if (self.xtiDelegate != delegate) {
        self.xtiDelegate.delegate = delegate;
    }
}
- (id<UINavigationControllerDelegate>)delegate {
    return self.xtiDelegate;
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

- (void)setPopViewController:(UIViewController *)popViewController {
    objc_setAssociatedObject(self, @selector(popViewController), popViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIViewController *)popViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setStartX:(CGFloat)startX {
    objc_setAssociatedObject(self, @selector(startX), @(startX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)startX {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
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
    NSNumber *openBackGesture = objc_getAssociatedObject(self, _cmd);
    if (openBackGesture) {
        return [openBackGesture boolValue];
    }
    self.xti_openBackGesture = UINavigationController.xti_openBackGesture;
    return YES;
}

+ (void)setXti_openBackGesture:(BOOL)xti_openBackGesture {
    objc_setAssociatedObject(self, @selector(xti_openBackGesture), @(xti_openBackGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (BOOL)xti_openBackGesture {
    NSNumber *openBackGesture = objc_getAssociatedObject(self, _cmd);
    if (openBackGesture) {
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
    if (hiddenTabbar) {
        return [hiddenTabbar boolValue];
    }
    self.xti_hiddenTabbarIfNonRootViewController = YES;
    return YES;
}

@end
