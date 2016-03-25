//
//  ParabolaTool.m
//  xinggou
//
//  Created by suya on 16/2/14.
//  Copyright © 2016年 suya. All rights reserved.
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
- (void)throwObject:(UIView *)obj from:(CGPoint)start to:(CGPoint)end endScale:(CGFloat )endScale
{
    UIBezierPath *path= [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(start.x, start.y)];
    [path addQuadCurveToPoint:CGPointMake(end.x+25,  end.y+25) controlPoint:CGPointMake(start.x - 180, start.y - 200)];
    [self throwObject:obj path:path isRotation:YES endScale:endScale];
}
/**
 *  将某个view或者layer从起点抛到终点
 *
 *  @param obj    被抛的物体
 *  @param start  起点坐标
 *  @param end    终点坐标
 *  @param path   贝赛尔曲线
 */
- (void)throwObject:(UIView *)obj path:(UIBezierPath *)path isRotation:(BOOL)isRotation endScale:(CGFloat)endScale
{
    self.showingView = obj;
    
    [self groupAnimation:path isRotation:isRotation endScale:endScale];
}
#pragma mark - 组合动画
-(void)groupAnimation:(UIBezierPath *)path
{
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animation.path = path.CGPath;
//    animation.rotationMode = kCAAnimationRotateAuto;
//    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    expandAnimation.duration = 0.5f;
//    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
//    expandAnimation.toValue = [NSNumber numberWithFloat:0.5f];
//    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    
//    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    narrowAnimation.beginTime = 0.5f;
//    narrowAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
//    narrowAnimation.duration = 1.5f;
//    narrowAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//    
//    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    CAAnimationGroup *groups = [CAAnimationGroup animation];
//    groups.animations = @[animation,expandAnimation,narrowAnimation];
//    groups.duration = 0.8f;
//    groups.removedOnCompletion=NO;
//    groups.fillMode=kCAFillModeForwards;
//    groups.delegate = self;
//    [self.showingView.layer addAnimation:groups forKey:@"group"];
    [self groupAnimation:path isRotation:YES  endScale:0.1f];
}

-(void)groupAnimation:(UIBezierPath *)path isRotation:(BOOL)isRotation endScale:(CGFloat )endScale
{
    [self groupAnimation:path endScale:endScale isRotation:isRotation animationDuration:0.9f];
}
-(void)groupAnimation:(UIBezierPath *)path endScale:(CGFloat )endScale isRotation:(BOOL)isRotation animationDuration:(CFTimeInterval)animationDuration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    narrowAnimation.duration = animationDuration;
    narrowAnimation.toValue = [NSNumber numberWithFloat:endScale];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = animationDuration;
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.3f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = animationDuration/0.3f;
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    if (isRotation) {
        groups.animations = @[animation,rotationAnimation,narrowAnimation];
    }else
    {
        groups.animations = @[animation,narrowAnimation];
    }
    
    groups.duration = animationDuration;
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
