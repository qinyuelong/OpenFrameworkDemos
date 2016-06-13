//
//  ProgressViewController.m
//  Facebook-POP-Demo
//
//  Created by snqu-ios on 16/6/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "ProgressViewController.h"
#import <POP.h>

@interface ProgressViewController ()

@property (nonatomic, strong) UIView *popCircle;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    [self resetCircle];
    
    [self.view addSubview:self.popCircle];
}

-(void)resetCircle{
    [self.popCircle.layer pop_removeAllAnimations];
    for (CAShapeLayer *layer in self.popCircle.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    self.popCircle.layer.transform = CATransform3DIdentity;
    [self.popCircle.layer setMasksToBounds:YES];
    [self.popCircle.layer setBackgroundColor:[UIColor colorWithRed:0.16 green:0.72 blue:1.0 alpha:1.0].CGColor];
    [self.popCircle.layer setCornerRadius:25.0];
    [self.popCircle setBounds:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    self.popCircle.layer.position = CGPointMake(self.view.center.x, 180.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)progressAction:(id)sender {
    [self.popCircle pop_removeAllAnimations];
    
    // config progress line
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.98].CGColor;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineJoin = kCALineJoinBevel;
    progressLayer.lineWidth = 26.0;
    progressLayer.strokeEnd = 0.0;
    
    UIBezierPath *progressLine = [UIBezierPath bezierPath];
    [progressLine moveToPoint:CGPointMake(25.0, 25.0)];
    [progressLine addLineToPoint:CGPointMake(800.0 - 25, 25.0)];
    progressLayer.path = progressLine.CGPath;
    
    [self.popCircle.layer addSublayer:progressLayer];
    
    
    //
    POPSpringAnimation *scaleAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnim.springBounciness = 5;
    scaleAnim.springSpeed = 12;
    scaleAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.3, 0.3)];
    
//    scaleAnim.completionBlock = ^(POPAnimation *anim, BOOL finished){
//        if (finished) {
//            self.popCircle.transform = CGAffineTransformMakeScale(0.3, 0.3);
//        }
//    };
    
    
    POPSpringAnimation *boundsAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    boundsAnim.springBounciness = 10;
    boundsAnim.springSpeed = 6;
    // 因为有 scale 一起做动画 所以宽度需要大些
    boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 800, 50)];
    
    // 开启了绘画上下文，动画结束后使用 UIGraphicsEndImageContext(); 清空了绘画上下文。这个主要是影响了画板的大小 (不懂)
    boundsAnim.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished) {
            // 这里我们没有使用 UIGraphicsBeginImageContext() 而是使用 UIGraphicsBeginImageContextWithOptions() 以此获取一个更清晰的绘图效果
            UIGraphicsBeginImageContextWithOptions(self.popCircle.frame.size, NO, 0.0);
            POPBasicAnimation *progressBoundsAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
            progressBoundsAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            progressBoundsAnim.duration = 1.0f;
            progressBoundsAnim.fromValue = @(0.0);
            progressBoundsAnim.toValue = @(1.0);
            
            [progressLayer pop_addAnimation:progressBoundsAnim forKey:@"animateBounds"];
            progressBoundsAnim.completionBlock = ^(POPAnimation *progresAnim, BOOL progreFfinished){
                if (progreFfinished) {
                    UIGraphicsEndImageContext();
                }
            };
        }
        
    };
    
    [self.popCircle.layer pop_addAnimation:boundsAnim forKey:@"bounds"];
    [self.popCircle.layer pop_addAnimation:scaleAnim forKey:@"scale"];
    
}

@end
