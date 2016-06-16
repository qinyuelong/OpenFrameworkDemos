//
//  MainSettingViewController.m
//  MyStarWars
//
//  Created by snqu-ios on 16/6/16.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "MainSettingViewController.h"
#import "SettingTableViewController.h"
#import "CircularRevealAnimator.h"

@interface MainSettingViewController (){
    BOOL revert;
}

@end

@implementation MainSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    revert = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[SettingTableViewController class]]) {
        SettingTableViewController *vc = (SettingTableViewController *)[segue destinationViewController];
        UITableView *tableView = vc.tableView;
        vc.maskActionBlock = ^(CGPoint point){
            CGPoint testViewPoint = [self.view convertPoint:point fromView:tableView];
            UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(testViewPoint.x - 250, testViewPoint.y - 50, 100, 100)];
            testView.backgroundColor = [UIColor whiteColor];
            testView.layer.borderColor = [UIColor orangeColor].CGColor;
            testView.layer.borderWidth = 1.0;
            [self.view addSubview:testView];
            
//            [self startCircularRevealAnimatorWithView:testView];
            [self testAnimator];
        };
    }
    
}


-(void)startCircularRevealAnimatorWithView:(UIView *)view{
    CALayer *tempLayer = [CALayer layer];
    tempLayer.backgroundColor = view.layer.borderColor;
    tempLayer.frame = view.bounds;
    [view.layer insertSublayer:tempLayer atIndex:0];
    CGFloat radius = MAX(view.frame.size.width / 2, view.frame.size.height / 2);
    CGPoint center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    CircularRevealAnimator *anim = [[CircularRevealAnimator alloc] initWithLayer:tempLayer center:center startRadius:0 endRadius:radius invert:NO];
    anim.duration = 5.0;
    anim.circularCompleted = ^(){
        [tempLayer removeFromSuperlayer];
    };
    [anim start];
}


-(void)testAnimator{
    // 根据点击point 计算 实际中需要
//    let radius: CGFloat = {
//        let x = max(center.x, frame.width - center.x)
//        let y = max(center.y, frame.height - center.y)
//        return sqrt(x * x + y * y)
//    }()
    
    CGFloat x = self.view.frame.size.width / 2;
    CGFloat y = self.view.frame.size.height / 2;
    CGFloat radius = sqrt(x*x + y*y);
    
    UIView *snapshort = [[UIView alloc] initWithFrame:self.view.bounds];
    snapshort.backgroundColor = [UIColor blueColor];
    [self.view addSubview:snapshort];
    CircularRevealAnimator *anim ;
    if (revert) {
        anim = [[CircularRevealAnimator alloc] initWithLayer:snapshort.layer center:self.view.center startRadius:radius endRadius:0 invert:revert];
    }else{
        anim = [[CircularRevealAnimator alloc] initWithLayer:snapshort.layer center:self.view.center startRadius:0 endRadius:radius invert:revert];
    }
    anim.duration = 2.5;
    anim.circularCompleted = ^(){
        [snapshort removeFromSuperview];
        revert = !revert;
    };
    [anim start];
}

@end
