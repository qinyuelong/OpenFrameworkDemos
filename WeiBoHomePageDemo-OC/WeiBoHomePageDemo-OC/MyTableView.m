//
//  MyTableView.m
//  WeiBoHomePageDemo-OC
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//


#import "MyTableView.h"

@implementation MyTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
