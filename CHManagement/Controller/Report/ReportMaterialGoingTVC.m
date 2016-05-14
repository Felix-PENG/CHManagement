//
//  ReportMaterialGoingTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportMaterialGoingTVC.h"
#import "ReportGoingCell.h"
#import "ReportMaterialDetailTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "AuditMaterialsVO.h"
#import "ErrorHandler.h"
#import "LoadMoreCell.h"
#import "UserShortVO.h"
#import "MyGroup.h"
#import "UserInfo.h"

#define GOINGSTATUS 0
#define IN_OFF 0

@interface ReportMaterialGoingTVC ()

@end

@implementation ReportMaterialGoingTVC{
    NSUInteger _page;
    NSMutableArray* _goingAuditMaterialsList;
    BOOL _noMoreData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _goingAuditMaterialsList = [NSMutableArray array];
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
    return _goingAuditMaterialsList.count > 0 ? _goingAuditMaterialsList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _goingAuditMaterialsList.count){
        ReportGoingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        
        AuditMaterialsVO* auditMaterials = [_goingAuditMaterialsList objectAtIndex:indexPath.row];
        
        UserShortVO* userShortVO = [auditMaterials user];
        NSString* userName = [userShortVO name];
        
        MyGroup* group = [auditMaterials group];
        NSString* role = [group name];
        
        [cell configureCellWithTitle:[auditMaterials name] withTime:[auditMaterials time] withUsername:userName withRole:role withDetail:[auditMaterials detail] withPrice:[auditMaterials money]];
        
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
    if(indexPath.row < _goingAuditMaterialsList.count){
        ReportMaterialDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportMaterialDetailTVC"];
        [detail setAuditMaterialsVO:[_goingAuditMaterialsList objectAtIndex:indexPath.row]];
        [detail setCheckable:NO];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadGoingAuditMaterialsWithPage:++_page];
    }
}

#pragma mark load data
- (void)loadGoingAuditMaterialsWithPage:(NSUInteger)page{
    NSInteger group_id = [UserInfo sharedInstance].groupId;
    NSInteger user_id = [UserInfo sharedInstance].id;
    
    if(self.choosedGroupId){
        group_id = self.choosedGroupId.integerValue;
    }
    
    if(page <= 1){
        [_goingAuditMaterialsList removeAllObjects];
    }
    
    [[NetworkManager sharedInstance]getAuditMaterialsListWithGroupId:group_id withStatus:GOINGSTATUS withIn_off:IN_OFF withPage:page withUserId:user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* auditMaterialsVOList = [response objectForKey:@"auditMaterialsVOList"];
            
            if(auditMaterialsVOList.count > 0){
                for(NSDictionary* dict in auditMaterialsVOList){
                    AuditMaterialsVO* auditMaterialsVO = [[AuditMaterialsVO alloc]initWithDictionary:dict error:nil];
                    [_goingAuditMaterialsList addObject:auditMaterialsVO];
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
    [self loadGoingAuditMaterialsWithPage:_page];
}


@end
