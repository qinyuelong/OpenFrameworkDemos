//
//  CurlingViewController.m
//  Facebook-POP-Demo
//
//  Created by snqu-ios on 16/6/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "CurlingViewController.h"
#import <pop/POP.h>

@interface CurlingViewController ()

@property (weak, nonatomic) IBOutlet UIView *curling;


@end

@implementation CurlingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)curlingPanGesture:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:{
            [self.curling.layer pop_removeAllAnimations];
            CGPoint translation = [gesture translationInView:self.view];
            CGPoint center = self.curling.center;
            center.x += translation.x;
            center.y += translation.y;
            self.curling.center = center;
            [gesture setTranslation:CGPointZero inView:self.curling];
            break;
        }
        
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            CGPoint velocity = [gesture velocityInView: self.view];
            [self addDecayPositionAnimationWithVelocity:velocity];
            break;
        }
            
        default:
            break;
    }
    
}

-(void)addDecayPositionAnimationWithVelocity:(CGPoint)velocity{
    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
    anim.velocity = [NSValue valueWithCGPoint:velocity];
    [self.curling.layer pop_addAnimation:anim forKey:@"decay"];
}

@end
