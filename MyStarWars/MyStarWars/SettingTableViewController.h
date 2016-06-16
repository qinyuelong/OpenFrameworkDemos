//
//  SettingTableViewController.h
//  MyStarWars
//
//  Created by snqu-ios on 16/6/16.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MaskActionBlock)(CGPoint center);

@interface SettingTableViewController : UITableViewController

@property (nonatomic, copy) MaskActionBlock maskActionBlock;

@end
