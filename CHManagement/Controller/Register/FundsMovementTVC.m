//
//  FundsMovementTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "FundsMovementTVC.h"
#import "RegisterCell.h"
#import "AddFundsMovementTVC.h"
#import "NetworkManager.h"
#import "BillVO.h"
#import "ResultVO.h"
#import "LoadMoreCell.h"
#import "Constants.h"

@interface FundsMovementTVC ()

@end

@implementation FundsMovementTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadDataWithPage:(NSUInteger)page
{
    [[NetworkManager sharedInstance] getBillsWithGroupId:self.groupID withPage:page completionHandler:^(NSDictionary *response) {
        ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        if (result.success == 0) {
            NSArray *list = [response objectForKey:@"billVOList"];
            if (list.count > 0) {
                for (NSDictionary *dict in list) {
                    BillVO *bill = [[BillVO alloc] initWithDictionary:dict error:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataList.count) {
        RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
        BillVO *bill = _dataList[indexPath.row];
        [cell setTitle:bill.in_off == BILL_IN ? @"进账" : @"出账" dateTime:bill.time group:bill.group.name user:bill.user.name detail:bill.detail money:bill.money];
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
        BillVO *bill = _dataList[indexPath.row];
        AddFundsMovementTVC *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddFundsMovementTVC"];
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
