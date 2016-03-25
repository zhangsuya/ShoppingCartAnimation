//
//  ParabolaTool.h
//  ShoppingCarAnimation
//
//  Created by suya on 16/2/14.
//  Copyright © 2016年 suya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ParabolaToolDelegate;
@interface ParabolaTool : NSObject
@property (nonatomic, assign) id<ParabolaToolDelegate>delegate;
@property (nonatomic, retain) UIView *showingView;

+ (ParabolaTool *)sharedTool;



/**
 *  将某个view或者layer从起点抛到终点
 *
 *  @param obj    被抛的物体
 *  @param path   贝赛尔曲线
 *  @param endScale   终点大小
 *  @param isRotation 是否旋转
 */
- (void)throwObject:(UIView *)obj path:(UIBezierPath *)path isRotation:(BOOL)isRotation endScale:(CGFloat)endScale;
@end
@protocol ParabolaToolDelegate <NSObject>

/**
 *  抛物线结束的回调
 */
@optional
- (void)animationDidFinish;

@end