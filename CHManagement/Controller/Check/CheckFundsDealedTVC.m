//
//  CheckFundsDealedTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "CheckFundsDealedTVC.h"
#import "CheckRejectedCell.h"
#import "ReportDetailTVC.h"
#import "LoadMoreCell.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "ErrorHandler.h"
#import "ReportGoingCell.h"

#define APPROVE_STATUS 3
#define REJECT_STATUS 2
#define DEALED_STATUS 1

static NSString * const ApproveCellIdentifier = @"ReportGoingCell";
static NSString * const RejectCellIdentifier = @"CheckRejectedCell";
static NSString * const LoadMoreCellIdentifier = @"LoadMoreCell";

@interface CheckFundsDealedTVC (){
    NSUInteger _page;
    NSMutableArray* _dealedFundsList;
    BOOL _noMoreData;
}


@end

@implementation CheckFundsDealedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dealedFundsList = [NSMutableArray array];
    // Do any additional setup after loading the view.
    
    UINib *nib = [UINib nibWithNibName:ApproveCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ApproveCellIdentifier];
    
    nib = [UINib nibWithNibName:RejectCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:RejectCellIdentifier];
    
    nib = [UINib nibWithNibName:LoadMoreCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:LoadMoreCellIdentifier];

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
    return _dealedFundsList.count > 0 ? _dealedFundsList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _dealedFundsList.count){
        AuditOthersVO* auditOthers = [_dealedFundsList objectAtIndex:indexPath.row];
        
        UserShortVO* userShortVO = [auditOthers user];
        NSString* userName = [userShortVO name];
        MyGroup* group = [auditOthers group];
        NSString* role = [group name];
        
        if(auditOthers.audit_status == APPROVE_STATUS){
            ReportGoingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ApproveCellIdentifier];
            
            [cell configureCellWithTitle:[auditOthers name] withTime:[auditOthers time] withUsername:userName withRole:role withDetail:[auditOthers detail] withPrice:[auditOthers money]];
            [cell hideExpireLabel];
            
            return cell;
        }else{
            CheckRejectedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:RejectCellIdentifier];
            
            [cell configureCellWithTitle:[auditOthers name] withTime:[auditOthers time] withUsername:userName withRole:role withDetail:[auditOthers detail] withPrice:[auditOthers money] withReason:[auditOthers reason]];
            
            return cell;
        }
    }else{
        LoadMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
        
        cell.status = _noMoreData ? NoMore : ClickToLoad;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _dealedFundsList.count){
        ReportDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportDetailTVC"];
        [detail setAuditOthersVO:[_dealedFundsList objectAtIndex:indexPath.row]];
        [detail setCheckable:NO];
        detail.delegate = (id<CheckUpdateProtocol>)self.parentViewController.parentViewController;
        [detail.navigationItem setTitle:@"经费单详情"];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadDealedFundsList:++_page];
    }
}

#pragma mark load data
- (void)loadDealedFundsList:(NSInteger)page{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[userData objectForKey:@"user_id"]integerValue];
    
    if(page <= 1){
        [_dealedFundsList removeAllObjects];
    }
    
    [[NetworkManager sharedInstance]getAuditOthersListWithStatus:DEALED_STATUS withPage:page withUserId:user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* auditOthersVOList = [response objectForKey:@"auditOthersVOList"];
            
            if(auditOthersVOList.count > 0){
                for(NSDictionary* billDict in auditOthersVOList){
                    AuditOthersVO* auditOthersVO = [[AuditOthersVO alloc]initWithDictionary:billDict error:nil];
                    [_dealedFundsList addObject:auditOthersVO];
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
    [self loadDealedFundsList:_page];
}

@end
