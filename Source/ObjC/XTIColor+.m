//
//  XTIColor.m
//  XTInputKit
//
//  Created by Input on 2018/2/3.
//  Copyright © 2018年 input. All rights reserved.
//

#import "XTIColor+.h"

@implementation UIColor (xtiExtension)
- (UIColor *)toColor:(UIColor *)color progress:(CGFloat)progress {
    if (progress >= 1) {
        return color;
    } else if (progress <=0 ) {
        return self;
    }
    const CGFloat *components1 = CGColorGetComponents(color.CGColor);
    const CGFloat *components2 = CGColorGetComponents(self.CGColor);
    CGFloat r, g, b, a;
    r = components1[0] - (components1[0]- components2[0]) * progress;
    g = components1[1] - (components1[1]- components2[1]) * progress;
    b = components1[2] - (components1[2]- components2[2]) * progress;
    a = components1[3] - (components1[3]- components2[3]) * progress;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (BOOL)isEqualColor:(UIColor *)color {
    const CGFloat *components1 = CGColorGetComponents(color.CGColor);
    const CGFloat *components2 = CGColorGetComponents(self.CGColor);
    CGFloat r, g, b, a;
    r = components1[0]- components2[0];
    g = components1[1]- components2[1];
    b = components1[2]- components2[2];
    a = components1[3]- components2[3];
    return (r + g + b + a) == 0;
}
@end
