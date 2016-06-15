//
//  CircularRevealAnimator.m
//  MyStarWars
//
//  Created by snqu-ios on 16/6/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "CircularRevealAnimator.h"

#import <QuartzCore/QuartzCore.h>

@interface CircularRevealAnimator()

@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong) CAShapeLayer *mask;
@property (nonatomic, strong) CABasicAnimation *animation;

@end


@implementation CircularRevealAnimator


-(instancetype)initWithLayer:(CALayer*)layer center:(CGPoint) center startRadius:(CGFloat) startRadius endRadius:(CGFloat)endRadius invert:(BOOL)invert;{
    self = [super init];
    if (self) {
        CGPathRef startCirclePath = CGPathCreateWithEllipseInRect([self SquareAroundCircle:center radius:startRadius], NULL);
        CGPathRef endCirclePath = CGPathCreateWithEllipseInRect([self SquareAroundCircle:center radius:endRadius], NULL);
        
        if (invert) {
            // 反转 path
        }
        
        _layer = layer;
        _mask = [CAShapeLayer layer];
        _mask.path = endCirclePath;
        _mask.fillRule = kCAFillRuleEvenOdd;
        
        _animation = [CABasicAnimation animationWithKeyPath:@"path"];
        _animation.fromValue = (__bridge id )(startCirclePath);
        _animation.toValue = (__bridge id)(endCirclePath);
        _animation.delegate = self;
        
    }
    return self;
}

-(CGRect)SquareAroundCircle:(CGPoint)center radius:(CGFloat)radius{
    return CGRectInset(CGRectMake(center.x, center.y, CGSizeZero.width, CGSizeZero.height), -radius, -radius);
}

-(void)setDuration:(CGFloat)duration{
    _animation.duration = duration;
}


-(void)setTimingFunction:(CAMediaTimingFunction *)timingFunction{
    _animation.timingFunction = _timingFunction;
}

-(void)start{
    _layer.mask = _mask;
    _mask.frame = _layer.bounds;
    [_mask addAnimation:self.animation forKey:@"erveal"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished{
    if (finished) {
        self.layer.mask = nil;
        self.animation.delegate = nil;
        
        if (self.circularCompleted) {
            self.circularCompleted();
        }
    }
}


@end
