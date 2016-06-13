//
//  AnimatableModel.m
//  Facebook-POP-Demo
//
//  Created by snqu-ios on 16/6/12.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "AnimatableModel.h"

@implementation AnimatableModel

-(void)setAnimatableValue:(CGFloat)animatableValue{
    _animatableValue = animatableValue;
    NSLog(@"%f", animatableValue);
}

@end
