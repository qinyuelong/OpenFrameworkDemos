//
//  CircularRevealAnimator.h
//  MyStarWars
//
//  Created by snqu-ios on 16/6/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef  void (^CircularCompleted)();

@interface CircularRevealAnimator : NSObject
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, copy) CAMediaTimingFunction *timingFunction;

@property (nonatomic, copy)CircularCompleted circularCompleted;

-(instancetype)initWithLayer:(CALayer*)layer center:(CGPoint) center startRadius:(CGFloat) startRadius endRadius:(CGFloat)endRadius invert:(BOOL)invert;

-(void)start;

@end
