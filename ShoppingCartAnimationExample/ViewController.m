//
//  ViewController.m
//  ShoppingCartAnimationExample
//
//  Created by Mac on 16/3/23.
//  Copyright © 2016年 suya. All rights reserved.
//

#import "ViewController.h"
#import "MCFireworksButton.h"
#import "ParabolaTool.h"
#import <objc/runtime.h>
#import "MCFireworksView.h"
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<ParabolaToolDelegate>
@property (nonatomic,strong)MCFireworksButton *shoppingCar;
@property (nonatomic,strong)UIImageView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 100, 100);
    [btn1 setImage:[UIImage imageNamed:@"goods1.jpg"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 100, 100, 100);
    [btn2 setImage:[UIImage imageNamed:@"goods2.jpg"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(200, 200, 100, 100);
    [btn3 setImage:[UIImage imageNamed:@"goods3.jpg"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.redView];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:self.shoppingCar];
    [ParabolaTool sharedTool].delegate = self;
    [self printIvars];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)printIvars
{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([ParabolaTool class], &outCount);
    for (unsigned int i = 0 ; i< outCount; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        printf("%s  的类型为%s \n",name,type);
    }
    printf("属性数目%d",outCount);
    free(ivars);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}
/**
 *  抛物线结束的回调
 */
- (void)animationDidFinish
{
    [self.redView removeFromSuperview];
    UILabel *numLabel = [self.shoppingCar viewWithTag:1002];
    
    numLabel.text = [NSString stringWithFormat:@"1"];
    [self.shoppingCar popOutsideWithDuration:0.5];
    [self.shoppingCar animate];
}
-(void)btnClicked:(UIButton *)btn
{
    /**
     *  通过坐标转换得到抛物线的起点和终点
     */
    CGRect parentRectA = btn.frame;
    CGRect parentRectB = [self.view convertRect:self.shoppingCar.frame toView:self.view];
    /**
     *  是否执行添加的动画
     */
    self.redView.frame = btn.frame;
    [self.redView setImage:btn.imageView.image];
    [self.view addSubview:self.redView];
    
    UIBezierPath *path= [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(parentRectA.origin.x, parentRectA.origin.y)];
    [path addQuadCurveToPoint:CGPointMake(parentRectB.origin.x+25,  parentRectB.origin.y+25) controlPoint:CGPointMake(parentRectA.origin.x + 280, parentRectA.origin.y + 200)];
    
    [[ParabolaTool sharedTool] throwObject:self.redView  path:path isRotation:YES endScale:0.1];
}
/**
 *  抛物线小红点
 *
 *  @return
 */
- (UIImageView *)redView
{
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth/2 -20, kDeviceWidth/2-20, 40, 40)];
        _redView.image = [UIImage imageNamed:@"overseas"];
        _redView.layer.cornerRadius = 10;
    }
    return _redView;
}
-(MCFireworksButton *)shoppingCar
{
    
    if(!_shoppingCar)
    {
        _shoppingCar = [MCFireworksButton buttonWithType:UIButtonTypeCustom];
        _shoppingCar.backgroundColor = [UIColor clearColor];
        _shoppingCar.frame = CGRectMake(kDeviceWidth-38 -17, kDeviceHeight-47 -15-44, 38, 38);
        _shoppingCar.alpha = 1;
        //    cart_count
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.tag = 1002;
        numLabel.frame = CGRectMake((38-12)/2, 3, 12, 12);
//        numLabel.text = [UserInfo shareUserInfo].userInfoModel.cart_count;
        if (numLabel.text.length ==2) {
//            numLabel.frame.origin.x = (38-24)/2;
//            numLabel.width = 24;
        }
        [numLabel setFont: [UIFont systemFontOfSize:10]];
        [self.shoppingCar addSubview:numLabel];
        _shoppingCar.particleImage = [UIImage imageNamed:@"Sparkle"];
        _shoppingCar.particleScale = 0.05;
        _shoppingCar.particleScaleRange = 0.02;
        [_shoppingCar setImage:[UIImage imageNamed:@"shoppingcart"] forState:UIControlStateNormal];
//        [_shoppingCar addTarget:self action:@selector(shoppingCarClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shoppingCar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
