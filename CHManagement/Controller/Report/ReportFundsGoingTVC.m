//
//  ReportFundsGoingTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportFundsGoingTVC.h"
#import "ReportGoingCell.h"
#import "ReportDetailTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "AuditOthersVO.h"
#import "ErrorHandler.h"
#import "LoadMoreCell.h"
#import "UserShortVO.h"
#import "MyGroup.h"

#define GOINGSTATUS 0

@interface ReportFundsGoingTVC ()

@end

@implementation ReportFundsGoingTVC{
    NSUInteger _page;
    NSMutableArray* _goingAuditOthersList;
    BOOL _noMoreData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _goingAuditOthersList = [NSMutableArray array];
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
    return _goingAuditOthersList.count > 0 ? _goingAuditOthersList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _goingAuditOthersList.count){
        ReportGoingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        
        AuditOthersVO* auditOthers = [_goingAuditOthersList objectAtIndex:indexPath.row];
        
        UserShortVO* userShortVO = [auditOthers user];
        NSString* userName = [userShortVO name];
        
        MyGroup* group = [auditOthers group];
        NSString* role = [group name];
        
        [cell configureCellWithTitle:[auditOthers name] withTime:[auditOthers time] withUsername:userName withRole:role withDetail:[auditOthers detail] withPrice:[auditOthers money]];
        
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
    if(indexPath.row < _goingAuditOthersList.count){
        ReportDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportDetailTVC"];
        [detail setAuditOthersVO:[_goingAuditOthersList objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadGoingAuditListWithPage:++_page];
    }
}

#pragma mark load data
- (void)loadGoingAuditListWithPage:(NSUInteger)page{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger group_id = [[userData objectForKey:@"group_id"]integerValue];
    NSInteger user_id = [[userData objectForKey:@"user_id"]integerValue];
    
    if(self.choosedGroupId){
        group_id = self.choosedGroupId.integerValue;
    }
    
    if(page <= 1){
        [_goingAuditOthersList removeAllObjects];
    }
    
    [[NetworkManager sharedInstance]getAuditOthersListWithGroupId:group_id withStatus:GOINGSTATUS withPage:page withUserId:user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* auditOthersVOList = [response objectForKey:@"auditOthersVOList"];
            
            if(auditOthersVOList.count > 0){
                for(NSDictionary* billDict in auditOthersVOList){
                    AuditOthersVO* auditOthersVO = [[AuditOthersVO alloc]initWithDictionary:billDict error:nil];
                    [_goingAuditOthersList addObject:auditOthersVO];
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
    [self loadGoingAuditListWithPage:_page];
}


@end
