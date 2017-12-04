//
//  ViewController.m
//  DragCollectionView
//
//  Created by apple on 2017/9/16.
//  Copyright © 2017年 apple. All rights reserved.
//  https://www.youtube.com/watch?v=BaB4uSvzEsU&t=228s

#import "ViewController.h"
#import "DragCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSIndexPath *currentDrapAndDropIndexPath;
@property (strong, nonatomic) UIView *currentDragAndDropSnapshot;

@property (strong, nonatomic) NSIndexPath *criticalIndexPath;// 边界临界值 超过这个值后拖动会发生异常 记录最后一个可用的值 当拖动超过边界值后用最后的边界值更新 UI

@end

@implementation ViewController{
    CGSize _itemSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds) / 2 - 10, 190);
    self.dataArray = [NSMutableArray arrayWithObjects:@"test01", @"test02", @"test03", @"test04",@"test01", @"test02", @"test03", @"test04",@"test01", @"test02", @"test03", @"test04",@"test01", @"test02", @"test03", @"test04", nil];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewLongPass:)];
    [self.collectionView addGestureRecognizer:gesture];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionViewLongPass:(UILongPressGestureRecognizer *)gesture{
     CGPoint currentLocation = [gesture locationInView:_collectionView];
    NSIndexPath *indexPathForLocation = [self.collectionView indexPathForItemAtPoint:currentLocation];
    if (indexPathForLocation == nil) {
        NSLog(@"---- nil ----");
    }else{
        _criticalIndexPath = indexPathForLocation;
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            if (_criticalIndexPath) {
                self.currentDrapAndDropIndexPath = _criticalIndexPath;
                DragCollectionViewCell *cell = (DragCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPathForLocation];
                self.currentDragAndDropSnapshot = [cell snapView];
                [self updateDrayAndDropSnapshotViewAlpha:0.0 center:cell.center transform:CGAffineTransformIdentity];
                [self.collectionView addSubview:self.currentDragAndDropSnapshot];
                
                [UIView animateWithDuration:0.25 animations:^{
                    [self updateDrayAndDropSnapshotViewAlpha:0.95 center:cell.center transform:CGAffineTransformMakeScale(1.05, 1.05)];
                    cell.contentView.alpha = 0.0;
                } completion:^(BOOL finished) {
                }];
                
            }
            break;
            
        case UIGestureRecognizerStateChanged:{
            self.currentDragAndDropSnapshot.center = currentLocation;
            if (_criticalIndexPath != nil) {
                id obj = [self.dataArray objectAtIndex:self.currentDrapAndDropIndexPath.item];
                [self.dataArray removeObjectAtIndex:self.currentDrapAndDropIndexPath.item];
                [self.dataArray insertObject:obj atIndex:_criticalIndexPath.item];
                [self.collectionView moveItemAtIndexPath:self.currentDrapAndDropIndexPath toIndexPath:_criticalIndexPath];
                self.currentDrapAndDropIndexPath = _criticalIndexPath;
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            DragCollectionViewCell *cell = (DragCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:_criticalIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                [self updateDrayAndDropSnapshotViewAlpha:0.0 center:cell.center transform:CGAffineTransformIdentity];
            } completion:^(BOOL finished) {
                [self.currentDragAndDropSnapshot removeFromSuperview];
                self.currentDragAndDropSnapshot = nil;
                cell.contentView.alpha = 1.0;
            }];

        }
            break;
            
        default:{
            DragCollectionViewCell *cell = (DragCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:_criticalIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                [self updateDrayAndDropSnapshotViewAlpha:0.0 center:cell.center transform:CGAffineTransformIdentity];
            } completion:^(BOOL finished) {
                [self.currentDragAndDropSnapshot removeFromSuperview];
                self.currentDragAndDropSnapshot = nil;
                cell.contentView.alpha = 1.0;
            }];
            
        }
            
            break;
    }
}


-(void)updateDrayAndDropSnapshotViewAlpha:(CGFloat) alpha center:(CGPoint)center transform:(CGAffineTransform)transform{
    if (self.currentDragAndDropSnapshot) {
        self.currentDragAndDropSnapshot.alpha = alpha;
        self.currentDragAndDropSnapshot.center = center;
        self.currentDragAndDropSnapshot.transform = transform;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArray count];
}


- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DragCollectionViewCell *cell = (DragCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.coverImageView.image = [UIImage imageNamed:_dataArray[indexPath.item]];
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _itemSize;
}

@end
