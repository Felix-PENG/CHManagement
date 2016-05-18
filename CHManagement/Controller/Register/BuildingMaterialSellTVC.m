//
//  BuildingMaterialSellTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "BuildingMaterialSellTVC.h"
#import "AddBuildingMaterialSellTVC.h"
#import "RegisterCell.h"
#import "BillMaterialsVO.h"
#import "LoadMoreCell.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "Constants.h"
#import "UserInfo.h"
#import "ErrorHandler.h"

@interface BuildingMaterialSellTVC ()

@end

@implementation BuildingMaterialSellTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadDataWithPage:(NSUInteger)page
{
    [[NetworkManager sharedInstance] getBillMaterialsListWithGroupId:self.groupID withStatus:STATUS_NOT_FINISHED withIn_off:BILL_OFF withPage:page completionHandler:^(NSDictionary *response) {
        ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        if (result.success == 0) {
            NSArray *list = [response objectForKey:@"billMaterialsVOList"];
            if (list.count > 0) {
                for (NSDictionary *dict in list) {
                    BillMaterialsVO *bill = [[BillMaterialsVO alloc] initWithDictionary:dict error:nil];
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
        BillMaterialsVO *bill = _dataList[indexPath.row];
        [cell setTitle:bill.name dateTime:bill.time group:bill.group.name user:bill.user.name detail:bill.detail money:bill.money];
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
        BillMaterialsVO *bill = _dataList[indexPath.row];
        AddBuildingMaterialSellTVC *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddBuildingMaterialSellTVC"];
        tvc.bill = bill;
        tvc.delegate = self;
        [self.navigationController pushViewController:tvc animated:YES];
    } else {
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadDataWithPage:++_page];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        BillMaterialsVO* billMaterials = [_dataList objectAtIndex:indexPath.row];
        
        [[NetworkManager sharedInstance]deleteBillMaterialsWithId:billMaterials.id withUserId:[UserInfo sharedInstance].id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            
            if(resultVO.success == 0){
                [_dataList removeObjectAtIndex:indexPath.row];
                if (_dataList.count > 0) {
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [self.tableView reloadData];
                }
            }else{
                UIAlertController* alertView = [ErrorHandler showErrorAlert:[resultVO message]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        }];
    }
}

@end
