//
//  MainTableViewCell.m
//  WeiBoHomePageDemo-OC
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MainTableViewCell.h"

@interface MainTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dynamicTableView.delegate = self;
    self.dynamicTableView.dataSource = self;
    self.needTableView.delegate = self;
    self.needTableView.dataSource = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubCell"
                                                            forIndexPath:indexPath];
    return cell;
    
}


#pragma mark - UIScrollViewDelegate
//滑动监控
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
    }
}


@end
