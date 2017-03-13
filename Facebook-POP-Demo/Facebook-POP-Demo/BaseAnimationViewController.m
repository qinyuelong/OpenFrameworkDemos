//
//  BaseAnimationViewController.m
//  Facebook-POP-Demo
//
//  Created by snqu-ios on 16/6/12.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "BaseAnimationViewController.h"
#import <pop/POP.h>

@interface BaseAnimationViewController ()

@property (weak, nonatomic) IBOutlet UIView *animationView;
@end

@implementation BaseAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _animationView.alpha = 0.0;

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)alphaAction:(id)sender {
    _animationView.alpha = 0.0;
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    anim.duration = 2.0;
    [anim setCompletionBlock:^(POPAnimation *animation, BOOL complete) {
        
    }];
    [_animationView pop_addAnimation:anim forKey:@"fade"];
}

- (IBAction)springAction:(id)sender {
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    [_animationView.layer pop_addAnimation:anim forKey:@""];
    
}

- (IBAction)decayAction:(id)sender {
    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.velocity = @(100.);
    [anim setCompletionBlock:^(POPAnimation *animation, BOOL complete) {
        NSLog(@"complete = %d", complete);
        if (complete) {
            POPDecayAnimation *newAnim = (POPDecayAnimation *)[_animationView.layer pop_animationForKey:@"slide"];
            if (newAnim) {
                newAnim.velocity = @(-100);
                [_animationView.layer pop_addAnimation:newAnim forKey:@"newSlide"];
            }
        }
    }];
    anim.removedOnCompletion = NO;
    [_animationView.layer pop_addAnimation:anim forKey:@"slide"];
    
}

@end
