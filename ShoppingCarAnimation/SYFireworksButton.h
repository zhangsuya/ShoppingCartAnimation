//
//  SYFireworksButton.h
//  ShoppingCartAnimationExample
//
//  Created by Mac on 16/3/25.
//  Copyright © 2016年 suya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYFireworksButton : UIButton
@property (strong, nonatomic) UIImage *particleImage;
@property (assign, nonatomic) CGFloat particleScale;
@property (assign, nonatomic) CGFloat particleScaleRange;

- (void)animate;
- (void)popOutsideWithDuration:(NSTimeInterval)duration;
- (void)popInsideWithDuration:(NSTimeInterval)duration;
@end
