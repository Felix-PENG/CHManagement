//
//  CHTableViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "CHTableViewController.h"

@interface CHTableViewController ()

@end

@implementation CHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // cell自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    // 刷新控件
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.refreshControl];
    [self.view sendSubviewToBack:self.refreshControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.repeatLoad){
        [self.refreshControl beginRefreshing];
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        self.repeatLoad = YES;
    }
}

#pragma mark - To be implemented

- (void)refresh
{
    
}

@end
