//
//  UIView+HRRoundView.h
//  HRRoundAndBorderedView
//
//  Created by Ivan Shevelev on 18/03/16.
//  Copyright © 2016 Ivan Shevelev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HRRoundView)

/**
 *  Color of the view's border. View.layer.borderColor inside.
 */
@property (nonatomic, strong, nonnull) IBInspectable UIColor *hrBorderColor;

/**
 *  Width of the view's border. View.layer.borderWidth inside.
 */
@property (nonatomic) IBInspectable CGFloat hrBorderWidth;

/**
 *  Radius of the view's corners. View.layer.cornerRadius inside.
 */
@property (nonatomic) IBInspectable CGFloat hrCornerRadius;

@end
