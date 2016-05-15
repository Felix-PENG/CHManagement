//
//  ReportFundsRejectedTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportFundsRejectedTVC.h"
#import "ReportRejectedCell.h"
#import "ReportRegisterTVC.h"
#import "ReportDetailTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "AuditOthersVO.h"
#import "ErrorHandler.h"
#import "LoadMoreCell.h"
#import "UserInfo.h"

#define REJECTSTATUS 2

@interface ReportFundsRejectedTVC () <ReportRejectedDelegate>

@end

@implementation ReportFundsRejectedTVC{
    NSUInteger _page;
    NSMutableArray* _rejectedAuditOthersList;
    BOOL _noMoreData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _rejectedAuditOthersList = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rejectedAuditOthersList.count > 0 ? _rejectedAuditOthersList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _rejectedAuditOthersList.count){
        ReportRejectedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        
        AuditOthersVO* auditOthers = [_rejectedAuditOthersList objectAtIndex:indexPath.row];
        
        UserShortVO* userShortVO = [auditOthers user];
        NSString* userName = [userShortVO name];
        
        MyGroup* group = [auditOthers group];
        NSString* role = [group name];
        
        NSString* reason = [auditOthers reason];
        if(!reason || [reason isEqualToString:@""]){
            reason = @"无";
        }
        [cell configureCellWithTitle:[auditOthers name] withTime:[auditOthers time] withUsername:userName withRole:role withDetail:[auditOthers detail] withPrice:[auditOthers money] withReason:reason];
        
        [cell setOffsetTag:indexPath.row];
        cell.delegate = self;
        
        return cell;
    }else{
        LoadMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.loadMoreCellIdentifier];
        
        cell.status = _noMoreData ? NoMore : ClickToLoad;
        return cell;
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _rejectedAuditOthersList.count){
        ReportDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportDetailTVC"];
        
        [detail setAuditOthersVO:[_rejectedAuditOthersList objectAtIndex:indexPath.row]];
        [detail setCheckable:NO];
        
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadRejectedAuditListWithPage:++_page];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        AuditOthersVO* auditOthersVO = [_rejectedAuditOthersList objectAtIndex:indexPath.row];
        
        [[NetworkManager sharedInstance]deleteAuditOthersWithId:auditOthersVO.id withUserId:[UserInfo sharedInstance].id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            
            if(resultVO.success == 0){
                [_rejectedAuditOthersList removeObjectAtIndex:indexPath.row];
                if (_rejectedAuditOthersList.count > 0) {
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

#pragma mark - ReportRejectedDelegate

- (void)modifyButtonPressed:(NSUInteger)index
{
    UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportRegisterTVC"];
    ReportRegisterTVC* reportRegisterTVC = (ReportRegisterTVC*)controller.topViewController;
    [reportRegisterTVC setAuditOthersVO:[_rejectedAuditOthersList objectAtIndex:index]];
    reportRegisterTVC.delegate = (id<AddRegisterProtocol>)self.parentViewController.parentViewController;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark load data
- (void)loadRejectedAuditListWithPage:(NSUInteger)page{
    NSInteger group_id = [UserInfo sharedInstance].groupId;
    NSInteger user_id = [UserInfo sharedInstance].id;
    
    if(self.choosedGroupId){
        group_id = self.choosedGroupId.integerValue;
    }
    
    if(page <= 1){
        [_rejectedAuditOthersList removeAllObjects];
    }
    
    [[NetworkManager sharedInstance]getAuditOthersListWithGroupId:group_id withStatus:REJECTSTATUS withPage:page withUserId:user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* auditOthersVOList = [response objectForKey:@"auditOthersVOList"];
            
            if(auditOthersVOList.count > 0){
                for(NSDictionary* billDict in auditOthersVOList){
                    AuditOthersVO* auditOthersVO = [[AuditOthersVO alloc]initWithDictionary:billDict error:nil];
                    [_rejectedAuditOthersList addObject:auditOthersVO];
                }
                _noMoreData = NO;
            }else{
                _noMoreData = YES;
            }
            
            [self.tableView reloadData];
        }else{
            UIAlertController* alertView = [ErrorHandler showErrorAlert:[resultVO message]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
        
        if([self.refreshControl isRefreshing]){
            [self.refreshControl endRefreshing];
        }
    }];
}

#pragma mark implement refresh
- (void)refresh{
    _page = 1;
    [self loadRejectedAuditListWithPage:_page];
}

@end
