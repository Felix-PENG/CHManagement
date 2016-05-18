//
//  RegisterTableViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "RegisterCell.h"

@interface RegisterTableViewController ()

@end

@implementation RegisterTableViewController

- (void)setGroupID:(NSInteger)groupID
{
    _groupID = groupID;
    [self refresh];
}

- (NSString *)cellIdentifier
{
    return @"RegisterCell";
}

- (NSString *)loadMoreCellIdentifier
{
    return @"LoadMoreCell";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINib *nib = [UINib nibWithNibName:self.cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:self.cellIdentifier];
    nib = [UINib nibWithNibName:self.loadMoreCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:self.loadMoreCellIdentifier];
    
    _page = 1;
    _dataList = [NSMutableArray array];
}

- (void)refresh
{
    [_dataList removeAllObjects];
    _page = 1;
    [self loadDataWithPage:_page];
}

- (void)loadDataWithPage:(NSUInteger)page
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count > 0 ? _dataList.count + 1 : 0;
}

#pragma mark - AddBuildingMaterialsDelegate

- (void)needRefresh
{
    self.repeatLoad = NO;
}

@end
