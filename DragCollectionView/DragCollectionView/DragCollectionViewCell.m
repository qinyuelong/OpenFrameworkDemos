//
//  DragCollectionViewCell.m
//  DragCollectionView
//
//  Created by apple on 2017/9/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DragCollectionViewCell.h"

@implementation DragCollectionViewCell

-(UIView *)snapView{
    UIView *view = [self snapshotViewAfterScreenUpdates:YES];
    CALayer *layer = view.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = 4.0;
    layer.shadowOpacity = 0.5;
    layer.shadowOffset = CGSizeMake(-4.0, 0.0);
    return view;
}

@end
