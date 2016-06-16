//
//  ViewController.m
//  MyStarWars
//
//  Created by snqu-ios on 16/6/13.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "ViewController.h"
#import "ProfileButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(ProfileButton *)sender {
    [sender animateTouchUpInside:^{
        NSLog(@"ok");
        [self performSegueWithIdentifier:@"presentSettings" sender:sender];
    }];
    
}
@end
