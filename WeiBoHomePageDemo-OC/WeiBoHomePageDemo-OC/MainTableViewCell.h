//
//  MainTableViewCell.h
//  WeiBoHomePageDemo-OC
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (assign, nonatomic) BOOL canScroll;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *dynamicTableView;
@property (weak, nonatomic) IBOutlet UITableView *needTableView;

@end
