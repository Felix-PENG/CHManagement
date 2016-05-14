//
//  CheckMaterialPurchaseDealedTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "CheckMaterialPurchaseDealedTVC.h"
#import "RegisterCell.h"
#import "ReportDetailTVC.h"
#import "LoadMoreCell.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "ErrorHandler.h"
#import "ReportGoingCell.h"
#import "AuditMaterialsVO.h"
#import "CheckRejectedCell.h"
#import "ReportMaterialDetailTVC.h"

#define APPROVE_STATUS 3
#define REJECT_STATUS 2
#define DEALED_STATUS 1
#define IN_OFF 0

static NSString * const ApproveCellIdentifier = @"ReportGoingCell";
static NSString * const RejectCellIdentifier = @"CheckRejectedCell";
static NSString * const LoadMoreCellIdentifier = @"LoadMoreCell";

@interface CheckMaterialPurchaseDealedTVC (){
    NSUInteger _page;
    NSMutableArray* _dealedMaterialsList;
    BOOL _noMoreData;

}

@end

@implementation CheckMaterialPurchaseDealedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dealedMaterialsList = [NSMutableArray array];
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
    return _dealedMaterialsList.count > 0 ? _dealedMaterialsList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _dealedMaterialsList.count){
        AuditMaterialsVO* auditMaterials = [_dealedMaterialsList objectAtIndex:indexPath.row];
        
        UserShortVO* userShortVO = [auditMaterials user];
        NSString* userName = [userShortVO name];
        
        MyGroup* group = [auditMaterials group];
        NSString* role = [group name];
        
        NSString* reason = [auditMaterials reason];
        if(!reason || [reason isEqualToString:@""]){
            reason = @"无";
        }
        
        if(auditMaterials.audit_status == APPROVE_STATUS){
            ReportGoingCell* cell = [self.tableView dequeueReusableCellWithIdentifier:ApproveCellIdentifier];
            
            [cell configureCellWithTitle:[auditMaterials name] withTime:[auditMaterials time] withUsername:userName withRole:role withDetail:[auditMaterials detail] withPrice:[auditMaterials money]];
            [cell hideExpireLabel];
            
            return cell;
        }else{
            CheckRejectedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:RejectCellIdentifier];
            
          [cell configureCellWithTitle:[auditMaterials name] withTime:[auditMaterials time] withUsername:userName withRole:role withDetail:[auditMaterials detail] withPrice:[auditMaterials money] withReason:reason];
            
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
    if(indexPath.row < _dealedMaterialsList.count){
        ReportMaterialDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportMaterialDetailTVC"];
        [detail setAuditMaterialsVO:[_dealedMaterialsList objectAtIndex:indexPath.row]];
        detail.delegate = (id<CheckUpdateProtocol>)self.parentViewController.parentViewController;
        [detail.navigationItem setTitle:@"建材买入单详情"];
        [detail setCheckable:NO];
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadDealedMaterialsListWithPage:++_page];
    }
}

#pragma mark load data
- (void)loadDealedMaterialsListWithPage:(NSUInteger)page{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[userData objectForKey:@"user_id"]integerValue];
    
    if(page <= 1){
        [_dealedMaterialsList removeAllObjects];
    }
    
    [[NetworkManager sharedInstance]getAuditMaterialsListWithStatus:DEALED_STATUS withIn_off:IN_OFF withPage:page withUserId:user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* auditMaterialsVOList = [response objectForKey:@"auditMaterialsVOList"];
            
            if(auditMaterialsVOList.count > 0){
                for(NSDictionary* dict in auditMaterialsVOList){
                    AuditMaterialsVO* auditMaterialsVO = [[AuditMaterialsVO alloc]initWithDictionary:dict error:nil];
                    [_dealedMaterialsList addObject:auditMaterialsVO];
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
    [self loadDealedMaterialsListWithPage:_page];
}

@end
