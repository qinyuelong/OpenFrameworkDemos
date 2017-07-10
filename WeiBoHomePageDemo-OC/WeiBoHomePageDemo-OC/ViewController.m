//
//  ViewController.m
//  WeiBoHomePageDemo-OC
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "MyTableView.h"
#import "MainTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MyTableView *tableView;
@property (assign, nonatomic) BOOL  canScroll;
@property (nonatomic, strong) MainTableViewCell *userMainCell;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _canScroll = YES;//是否可以滑动
    //顶级滑动 子级不能滑动
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onOtherScrollToTop:)
                                                 name:@"kLeaveTopNtf"
                                               object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //要减去导航栏 状态栏 以及 sectionheader的高度
    return self.view.frame.size.height-64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.userMainCell) {
        self.userMainCell =[tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"
                                                           forIndexPath:indexPath];
    }
    
    return self.userMainCell;
}

//子控制器到顶部了 主控制器可以滑动
- (void)onOtherScrollToTop:(NSNotification *)ntf {
    self.canScroll = YES;
    self.userMainCell.canScroll = NO;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y-64;
    if (scrollView.contentOffset.y >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        if (_canScroll) {
            _canScroll = NO;
            self.userMainCell.canScroll = YES;
        }
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
    }
}

@end
