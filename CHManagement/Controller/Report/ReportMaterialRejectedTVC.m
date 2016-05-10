//
//  ReportMaterialRejectedTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportMaterialRejectedTVC.h"
#import "ReportRejectedCell.h"
#import "ReportMaterialRegisterTVC.h"
#import "ReportMaterialDetailTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "AuditMaterialsVO.h"
#import "ErrorHandler.h"
#import "LoadMoreCell.h"

#define REJECTSTATUS 2
#define IN_OFF 0

@interface ReportMaterialRejectedTVC () <ReportRejectedDelegate>

@end

@implementation ReportMaterialRejectedTVC{
    NSUInteger _page;
    NSMutableArray* _rejectedAuditMaterialsList;
    BOOL _noMoreData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _rejectedAuditMaterialsList = [NSMutableArray array];
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
    return _rejectedAuditMaterialsList.count > 0 ? _rejectedAuditMaterialsList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _rejectedAuditMaterialsList.count){
        ReportRejectedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        
        AuditMaterialsVO* auditMaterials = [_rejectedAuditMaterialsList objectAtIndex:indexPath.row];
        
        UserShortVO* userShortVO = [auditMaterials user];
        NSString* userName = [userShortVO name];
        
        MyGroup* group = [auditMaterials group];
        NSString* role = [group name];
        
        NSString* reason = [auditMaterials reason];
        if(!reason || [reason isEqualToString:@""]){
            reason = @"无";
        }
        [cell configureCellWithTitle:[auditMaterials name] withTime:[auditMaterials time] withUsername:userName withRole:role withDetail:[auditMaterials detail] withPrice:[auditMaterials money] withReason:reason];
        
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
    if(indexPath.row < _rejectedAuditMaterialsList.count){
        ReportMaterialDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportMaterialDetailTVC"];
        
        [detail setAuditMaterialsVO:[_rejectedAuditMaterialsList objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadRejectedAuditMaterialsListWithPage:++_page];
    }
}

#pragma mark - ReportRejectedDelegate

- (void)modifyButtonPressed:(NSUInteger)index
{
    UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportMaterialRegisterTVC"];
    [(ReportMaterialRegisterTVC*)controller.topViewController setAuditMaterialsVO: [_rejectedAuditMaterialsList objectAtIndex:index]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark load data
- (void)loadRejectedAuditMaterialsListWithPage:(NSUInteger)page{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger group_id = [[userData objectForKey:@"group_id"]integerValue];
    NSInteger user_id = [[userData objectForKey:@"user_id"]integerValue];
    
    if(self.choosedGroupId){
        group_id = self.choosedGroupId.integerValue;
    }
    
    if(page <= 1){
        [_rejectedAuditMaterialsList removeAllObjects];
    }
    
    [[NetworkManager sharedInstance]getAuditMaterialsListWithGroupId:group_id withStatus:REJECTSTATUS withIn_off:IN_OFF withPage:page withUserId:user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* auditMaterialsVOList = [response objectForKey:@"auditMaterialsVOList"];
            
            if(auditMaterialsVOList.count > 0){
                for(NSDictionary* dict in auditMaterialsVOList){
                    AuditMaterialsVO* auditMaterialsVO = [[AuditMaterialsVO alloc]initWithDictionary:dict error:nil];
                    [_rejectedAuditMaterialsList addObject:auditMaterialsVO];
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
    [self loadRejectedAuditMaterialsListWithPage:_page];
}

@end
