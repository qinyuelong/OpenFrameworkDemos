//
//  AnimationPropertiesViewController.m
//  Facebook-POP-Demo
//
//  Created by snqu-ios on 16/6/12.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//  http://geeklu.com/2014/05/facebook-pop-usage/
// http://www.hmttommy.com/2015/11/26/facebookpop/


#import "AnimationPropertiesViewController.h"
#import <pop/POP.h>
#import "AnimatableModel.h"

@interface AnimationPropertiesViewController ()

@property (nonatomic, weak) IBOutlet UIView *animationView;
@property (nonatomic, strong) AnimatableModel *animatableModel;
@end

@implementation AnimationPropertiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _animatableModel = [[AnimatableModel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)inerPoppertiesAction:(id)sender {
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerBounds];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    [_animationView.layer pop_addAnimation:anim forKey:nil];
}


- (IBAction)customPorpertiesAction:(id)sender {
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:@"com.foo.test" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(AnimatableModel *obj, CGFloat values[]){
            values[0] = [obj animatableValue];
        };
        
        prop.writeBlock = ^(AnimatableModel *obj, const CGFloat values[]){
            [obj setAnimatableValue:values[0]];
        };
        
        // 阈值
        prop.threshold = 0.01;
    }];
    anim.toValue = @(100);
    [_animatableModel pop_addAnimation:anim forKey:@"customProperties"];
    
}

@end
