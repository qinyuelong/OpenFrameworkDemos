//
//  ViewController.m
//  DragableTableView
//
//  Created by qinge on 2018/4/4.
//  Copyright © 2018年 qin. All rights reserved.
//

#import "ViewController.h"
#import "DragableTableView.h"
#import "DragableTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet DragableTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.rowHeight = 80;
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DragableTableViewCell *cell = (DragableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.orderLabel.text = [[NSString alloc] initWithFormat:@"item: %ld", indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

@end
