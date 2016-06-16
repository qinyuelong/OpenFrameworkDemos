//
//  SettingTableViewController.m
//  MyStarWars
//
//  Created by snqu-ios on 16/6/16.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import "SettingTableViewController.h"


@interface SettingTableViewController (){
    CGFloat tableviewOffset;
    CGFloat beforeAppearOffset;
}
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundImageViewWidthConstraint;

//@property (nonatomic)


@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableviewOffset = [UIScreen mainScreen].bounds.size.height < 600 ? 215 : 225;
    beforeAppearOffset = 400.0;
    
    self.tableView.backgroundView = self.backgroundView;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(tableviewOffset, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -beforeAppearOffset);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.contentOffset = CGPointMake(0, -tableviewOffset);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    _backgroundViewHeightConstraint.constant = MAX(self.navigationController.navigationBar.bounds.size.height + scrollView.contentInset.top - scrollView.contentOffset.y, 0);
//    _backgroundImageViewWidthConstraint.constant = self.navigationController.navigationBar.bounds.size.height - scrollView.contentInset.top - scrollView.contentOffset.y * 0.8;
}


- (IBAction)darkDidChange:(UIView *)sender {
    CGPoint point = [self.tableView convertPoint:sender.center fromView:sender.superview];
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    if (self.maskActionBlock) {
        self.maskActionBlock(point);
    }
}


@end
