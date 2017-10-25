//
//  UIView+HRRoundView.m
//  HRRoundAndBorderedView
//
//  Created by Ivan Shevelev on 18/03/16.
//  Copyright © 2016 Ivan Shevelev. All rights reserved.
//

#import "UIView+HRRoundView.h"

@implementation UIView (HRRoundView)

#pragma mark - Border Color

- (void)setHrBorderColor:(UIColor *)hrBorderColor {
    self.layer.borderColor = hrBorderColor.CGColor;
}

- (UIColor *)hrBorderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

#pragma mark - Border Width

- (void)setHrBorderWidth:(CGFloat)hrBorderWidth {
    self.layer.borderWidth = hrBorderWidth;
}

- (CGFloat)hrBorderWidth{
    return self.layer.borderWidth;
}

#pragma mark - Corner Radius

- (void)setHrCornerRadius:(CGFloat)hrCornerRadius {
    self.layer.cornerRadius = hrCornerRadius;
}

- (CGFloat)hrCornerRadius {
    return self.layer.cornerRadius;
}

@end
