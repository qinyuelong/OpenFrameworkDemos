//
//  CardFlyViewController.m
//  Facebook-POP-Demo
//
//  Created by snqu-ios on 16/6/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "CardFlyViewController.h"
#import <POP.h>

@interface CardFlyViewController ()
@property (weak, nonatomic) IBOutlet UIView *flyCard;

@end

@implementation CardFlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.flyCard.layer setCornerRadius:5.0];
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_4/8.0);
    [self.flyCard.layer setAffineTransform:rotateTransform];
    self.flyCard.layer.opacity = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)flyCardAction:(id)sender {
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_4/8.0);
    [self.flyCard.layer setAffineTransform:rotateTransform];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.fromValue = @-200;
    anim.toValue = @(self.view.center.y);
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.toValue = @1.0;
    
    POPBasicAnimation *rotationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnim.beginTime = CACurrentMediaTime() + 0.1;
    rotationAnim.toValue = @(0);
    
    
    [self.flyCard.layer pop_addAnimation:anim forKey:@"spring"];
    [self.flyCard.layer pop_addAnimation:opacityAnim forKey:@"opacity"];
    [self.flyCard.layer pop_addAnimation:rotationAnim forKey:@"rotation"];
}

@end
