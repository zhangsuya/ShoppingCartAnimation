//
//  SYFireworksView.h
//  ShoppingCartAnimationExample
//
//  Created by Mac on 16/3/25.
//  Copyright © 2016年 suya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYFireworksView : UIView
@property (nonatomic,setter = setIsSelected:) BOOL isSelected;
@property (strong, nonatomic) UIImage *particleImage;
@property (assign, nonatomic) CGFloat particleScale;
@property (assign, nonatomic) CGFloat particleScaleRange;

- (void)animate;
@end
