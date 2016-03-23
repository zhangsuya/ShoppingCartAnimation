//
//  ParabolaTool.m
//  xinggou
//
//  Created by Mac on 16/2/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ParabolaTool.h"
static ParabolaTool *s_sharedInstance = nil;

@implementation ParabolaTool
+ (ParabolaTool *)sharedTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!s_sharedInstance) {
            s_sharedInstance = [[[self class] alloc] init];
        }
    });

    
    return s_sharedInstance;
}

/**
 *  将某个view或者layer从起点抛到终点
 *
 *  @param obj    被抛的物体
 *  @param start  起点坐标
 *  @param end    终点坐标
 */
- (void)throwObject:(UIView *)obj from:(CGPoint)start to:(CGPoint)end
{
    UIBezierPath *path= [UIBezierPath bezierPath];
    [self throwObject:obj from:start to:end path:path];
}
/**
 *  将某个view或者layer从起点抛到终点
 *
 *  @param obj    被抛的物体
 *  @param start  起点坐标
 *  @param end    终点坐标
 *  @param path   贝赛尔曲线
 */
- (void)throwObject:(UIView *)obj from:(CGPoint)start to:(CGPoint)end path:(UIBezierPath *)path
{
    self.showingView = obj;
    [path moveToPoint:CGPointMake(start.x, start.y)];
    [path addQuadCurveToPoint:CGPointMake(end.x+25,  end.y+25) controlPoint:CGPointMake(start.x - 180, start.y - 200)];
    [self groupAnimation:path];
}
#pragma mark - 组合动画
-(void)groupAnimation:(UIBezierPath *)path
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [self.showingView.layer addAnimation:groups forKey:@"group"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidFinish)]) {
        [self.delegate performSelector:@selector(animationDidFinish) withObject:nil];
    }
    self.showingView = nil;
}


@end
