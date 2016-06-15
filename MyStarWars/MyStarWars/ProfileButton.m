//
//  ProfileButton.m
//  MyStarWars
//
//  Created by snqu-ios on 16/6/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "ProfileButton.h"
#import "CircularRevealAnimator.h"

const CGFloat buttonPadding = 50;

@interface ProfileButton()

@property (nonatomic, strong)CALayer *fillLayer;

@end

@implementation ProfileButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpProfileButton];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpProfileButton];        
    }
    return self;
}

-(CGSize)intrinsicContentSize{
    return CGSizeMake(self.frame.size.width + buttonPadding , self.frame.size.height);
}

-(void)setUpProfileButton{
    self.layer.cornerRadius = 27;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:1.0 green:232 / 255.0 blue:31 / 255.0 alpha:1.0].CGColor;
}

-(void)animateTouchUpInside:(CompletionBlock)completionBlock{
    self.userInteractionEnabled = NO;
    self.layer.masksToBounds = YES;
    
    _fillLayer = [CALayer layer];
    _fillLayer.backgroundColor = self.layer.borderColor;
    _fillLayer.frame = self.layer.bounds;
    [self.layer insertSublayer:_fillLayer atIndex:0];
    
    CGPoint center = CGPointMake(CGRectGetMidX(_fillLayer.bounds), CGRectGetMidY(_fillLayer.bounds));
    CGFloat radius = MAX(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CircularRevealAnimator *revealAnimator = [[CircularRevealAnimator alloc] initWithLayer:_fillLayer center:center startRadius:0 endRadius:radius invert:NO];
    revealAnimator.duration = 0.3;
    revealAnimator.circularCompleted = ^(){
        
        // hide fillLayer
        _fillLayer.opacity = 0;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        anim.fromValue = @(1.0);
        anim.toValue = @(0.0);
        anim.duration = 0.2;
        anim.delegate = self;
        [_fillLayer addAnimation:anim forKey:@"opacity"];
        
    };
    [revealAnimator start];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self.fillLayer removeFromSuperlayer];
        self.userInteractionEnabled = YES;
    }
}

@end
