//
//  XTIColor.h
//  XTInputKit
//
//  Created by Input on 2018/2/3.
//  Copyright © 2018年 input. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (xtiCommonExtension)
- (UIColor *)toColor:(UIColor *)color progress:(CGFloat)progress;
- (BOOL)isEqualColor:(UIColor *)color;
@end
