//
//  CheckFundsUndealTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "CheckFundsUndealTVC.h"
#import "ReportGoingCell.h"
#import "ReportDetailTVC.h"
#import "LoadMoreCell.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "ErrorHandler.h"

#define UNDEALSTATUS 0

static NSString * const CellIdentifier = @"ReportGoingCell";
static NSString * const LoadMoreCellIdentifier = @"LoadMoreCell";

@interface CheckFundsUndealTVC (){
    NSUInteger _page;
    NSMutableArray* _undealFundsList;
    BOOL _noMoreData;
}
@end

@implementation CheckFundsUndealTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _undealFundsList = [NSMutableArray array];
    
    UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
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
    return _undealFundsList.count > 0 ? _undealFundsList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _undealFundsList.count){
        ReportGoingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        AuditOthersVO* auditOthers = [_undealFundsList objectAtIndex:indexPath.row];
        
        UserShortVO* userShortVO = [auditOthers user];
        NSString* userName = [userShortVO name];
        
        MyGroup* group = [auditOthers group];
        NSString* role = [group name];
        
        [cell configureCellWithTitle:[auditOthers name] withTime:[auditOthers time] withUsername:userName withRole:role withDetail:[auditOthers detail] withPrice:[auditOthers money]];
        
        return cell;
    }else{
        LoadMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
        
        cell.status = _noMoreData ? NoMore : ClickToLoad;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _undealFundsList.count){
        ReportDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportDetailTVC"];
        [detail setAuditOthersVO:[_undealFundsList objectAtIndex:indexPath.row]];
        [detail setCheckable:YES];
        detail.delegate = (id<CheckUpdateProtocol>)self.parentViewController.parentViewController;
        [detail.navigationItem setTitle:@"经费审核"];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadUndealFundsList:++_page];
    }
}

#pragma mark load data
- (void)loadUndealFundsList:(NSInteger)page{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[userData objectForKey:@"user_id"]integerValue];
    
    if(page <= 1){
        [_undealFundsList removeAllObjects];
    }
    
    [[NetworkManager sharedInstance]getAuditOthersListWithStatus:UNDEALSTATUS withPage:page withUserId:user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* auditOthersVOList = [response objectForKey:@"auditOthersVOList"];
            
            if(auditOthersVOList.count > 0){
                for(NSDictionary* billDict in auditOthersVOList){
                    AuditOthersVO* auditOthersVO = [[AuditOthersVO alloc]initWithDictionary:billDict error:nil];
                    [_undealFundsList addObject:auditOthersVO];
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
    [self loadUndealFundsList:_page];
}

@end
