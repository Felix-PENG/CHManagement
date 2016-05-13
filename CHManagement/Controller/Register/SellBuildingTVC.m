//
//  SellBuildingTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "SellBuildingTVC.h"
#import "RegisterCell.h"
#import "AddSellBuildingTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "BillBuildingVO.h"
#import "LoadMoreCell.h"

@interface SellBuildingTVC ()

@end

@implementation SellBuildingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadDataWithPage:(NSUInteger)page
{
    [[NetworkManager sharedInstance] getBillBuildingsWithGroupId:self.groupID withPage:page completionHandler:^(NSDictionary *response) {
        ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        if (result.success == 0) {
            NSArray *list = [response objectForKey:@"billBuildingVOList"];
            if (list.count > 0) {
                for (NSDictionary *dict in list) {
                    BillBuildingVO *bill = [[BillBuildingVO alloc] initWithDictionary:dict error:nil];
                    [_dataList addObject:bill];
                }
                _noMoreData = NO;
            } else {
                _noMoreData = YES;
            }
            [self.tableView reloadData];
        } else {
            
        }
        if (self.refreshControl.isRefreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataList.count) {
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
        BillBuildingVO *bill = _dataList[indexPath.row];
        [cell setTitle:bill.detail dateTime:bill.time group:bill.group.name user:bill.user.name detail:bill.purchaser_phone money:bill.money];
        return cell;
    } else {
        LoadMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.loadMoreCellIdentifier];
        cell.status = _noMoreData ? NoMore : ClickToLoad;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataList.count) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        BillBuildingVO *bill = _dataList[indexPath.row];
        AddSellBuildingTVC *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddSellBuildingTVC"];
        tvc.bill = bill;
        tvc.delegate = self;
        [self.navigationController pushViewController:tvc animated:YES];
    } else {
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadDataWithPage:++_page];
    }
}

@end
