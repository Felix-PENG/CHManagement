//
//  CHTableViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "CHTableViewController.h"

@interface CHTableViewController ()

@property (nonatomic, assign) BOOL repeatLoad;

@end

@implementation CHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // cell自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)refresh
{
    
}

@end
