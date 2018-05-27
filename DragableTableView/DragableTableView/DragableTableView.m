//
//  DragableTableView.m
//  DragableTableView
//
//  Created by qinge on 2018/4/4.
//  Copyright © 2018年 qin. All rights reserved.
//

#import "DragableTableView.h"

typedef enum{
    RTSnapshotMeetsEdgeTop,
    RTSnapshotMeetsEdgeBottom,
}RTSnapshotMeetsEdge;

@interface DragableTableView()
/**对被选中的cell的截图*/
@property (nonatomic, strong) UIView *snapshot;
/**被选中的cell的原始位置*/
@property (nonatomic, strong) NSIndexPath *originalIndexPath;
/**被选中的cell的新位置*/
@property (nonatomic, strong) NSIndexPath *relocatedIndexPath;
/**cell被拖动到边缘后开启，tableview自动向上或向下滚动*/
@property (nonatomic, strong) CADisplayLink *autoScrollTimer;
/**记录手指所在的位置*/
@property (nonatomic, assign) CGPoint fingerLocation;
/**自动滚动的方向*/
@property (nonatomic, assign) RTSnapshotMeetsEdge autoScrollDirection;

@end

@implementation DragableTableView

- (void)awakeFromNib{
    [super awakeFromNib];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self addGestureRecognizer:longPress];
}

#pragma mark - Gesture methods

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress{
    _fingerLocation = [longPress locationInView:self];
    _relocatedIndexPath = [self indexPathForRowAtPoint:_fingerLocation];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            _originalIndexPath = [self indexPathForRowAtPoint:_fingerLocation];
            if (_originalIndexPath) {
                [self cellSelectedAtIndexPath: _originalIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint center = _snapshot.center;
            center.y = _fingerLocation.y;
            _snapshot.center = center;
            // 检测手势拖动是否到 tableView 边缘 到边缘后自动滚动内容
            if ([self checkIfSnapshotMeetsEdge]) {
                [self startAutoScrollTimer];
            }else{
                [self stopAutoScrollTimer];
            }
            _relocatedIndexPath = [self indexPathForRowAtPoint:_fingerLocation];
            if (_relocatedIndexPath && ![_relocatedIndexPath isEqual:_originalIndexPath]) {
                [self cellRelocatedToNewIndexPath:_relocatedIndexPath];
            }
            break;
        }
            
        //长按手势结束或被取消，移除截图，显示cell
        default:
            [self stopAutoScrollTimer];
            [self didEndDraging];
            break;
    }
}


#pragma makr - 手势开始添加 snapShot
-(void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    _snapshot = [self customSnapshotFromView:cell];
    [self addSubview:_snapshot];
    _snapshot.center = cell.center;
    cell.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        _snapshot.transform = CGAffineTransformMakeScale(1.03, 1.03);
    }];
}


#pragma makr -  拖拽结束，显示cell，并移除截图
- (void)didEndDraging{
    UITableViewCell *cell = [self cellForRowAtIndexPath:_originalIndexPath];
    [UIView animateWithDuration:0.25 animations:^{
        cell.hidden = NO;
        _snapshot.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_snapshot removeFromSuperview];
        _snapshot = nil;
        _originalIndexPath = nil;
        _relocatedIndexPath = nil;
    }];
}

#pragma mark - 检查截图是否到达边缘，并作出响应
- (BOOL)checkIfSnapshotMeetsEdge{
    CGFloat minY = CGRectGetMinY(_snapshot.frame);
    CGFloat maxY = CGRectGetMaxY(_snapshot.frame);
    
    if (minY < self.contentOffset.y) {
        _autoScrollDirection = RTSnapshotMeetsEdgeTop;
        return YES;
    }
    
    if (maxY > self.contentOffset.y + self.bounds.size.height) {
        _autoScrollDirection = RTSnapshotMeetsEdgeBottom;
        return YES;
    }
    
    return NO;
}

#pragma mark - 截图被移动到新的indexPath范围，这时先更新数据源，重排数组，再将cell移至新位置
- (void)cellRelocatedToNewIndexPath:(NSIndexPath *)indexPath{
    [self moveRowAtIndexPath:_originalIndexPath toIndexPath:indexPath];
    _originalIndexPath = indexPath;
}

#pragma mark - 创建定时器并运行
-(void)startAutoScrollTimer{
    if (!_autoScrollTimer) {
        _autoScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAutoScroll:)];
        [_autoScrollTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - 停止定时器并销毁
-(void)stopAutoScrollTimer{
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
    }
}

-(void)startAutoScroll:(CADisplayLink *)displayLink{
    static CGFloat pixelSpeed = 4;
    if (_autoScrollDirection == RTSnapshotMeetsEdgeTop) {
        // 手势拖动向上 表格内容需要向下滚动
        if (self.contentOffset.y > 0 ) {
            [self setContentOffset:CGPointMake(0, self.contentOffset.y - pixelSpeed)];
            _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y - pixelSpeed);
        }
    }else{
        // 手势向下拖动 表格内容向上滚动
        if (self.contentOffset.y + CGRectGetHeight(self.frame) < self.contentSize.height) {
            [self setContentOffset:CGPointMake(0, self.contentOffset.y + pixelSpeed)];
            _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y + pixelSpeed);
        }
    }
    
    _relocatedIndexPath = [self indexPathForRowAtPoint:_snapshot.center];
    if (_relocatedIndexPath && ![_relocatedIndexPath isEqual:_originalIndexPath]) {
        [self cellRelocatedToNewIndexPath:_relocatedIndexPath];
    }
}

/** 返回一个给定view的截图. */
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, YES, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.center = inputView.center;
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

# pragma mark - Private methods
/**修改数据源，通知外部更新数据源*/
- (void)updateDataSource{
    //通过DataSource代理获得原始数据源数组
//    NSMutableArray *tempArray = [NSMutableArray array];
//    if ([self.dataSource respondsToSelector:@selector(originalArrayDataForTableView:)]) {
//        [tempArray addObjectsFromArray:[self.dataSource originalArrayDataForTableView:self]];
//    }
}


/**
 *  检查数组是否为嵌套数组
 *  @param array 需要被检测的数组
 *  @return 返回YES则表示是嵌套数组
 */
- (BOOL)nestedArrayCheck:(NSArray *)array{
    for (id obj in array) {
        if ([obj isKindOfClass:[NSArray class]]) {
            return YES;
        }
    }
    return NO;
}


@end
