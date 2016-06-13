//
//  NumberGradualViewController.m
//  Facebook-POP-Demo
//
//  Created by snqu-ios on 16/6/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "NumberGradualViewController.h"
#import <pop/POP.h>

@interface NumberGradualViewController ()
@property (weak, nonatomic) IBOutlet UILabel *gradualLabel;

@end

@implementation NumberGradualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gradualLabel.text = @"0.0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gradualAction:(UIButton *)sender {
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = 10;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id obj, CGFloat values[]){
            NSLog(@"value[0] = %f", values[0]);
            values[0] = [[obj description] floatValue];
            
        };
        
        prop.writeBlock = ^(id obj, const CGFloat values[]){
            ((UILabel *)obj).text = [NSString stringWithFormat:@"%.2f", values[0]];
        };
        
        prop.threshold = 0.01;
    }];
    
    anim.completionBlock = ^(POPAnimation *popAnim, BOOL finished){
        if (finished) {
            NSLog(@" Animation finised ");
        }else{
            NSLog(@" Animation ... ");
        }
    };
    
    anim.property = prop;
    
    anim.fromValue = @(0.0);
    anim.toValue = @(10.0);
    
    [_gradualLabel pop_addAnimation:anim forKey:@"gradual"];
    
}

@end
