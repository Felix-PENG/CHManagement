//
//  CheckMaterialPurchaseUndealTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "CheckMaterialPurchaseUndealTVC.h"
#import "ReportGoingCell.h"
#import "ReportMaterialDetailTVC.h"
#import "LoadMoreCell.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "ErrorHandler.h"
#import "AuditMaterialsVO.h"

#define UNDEALSTATUS 0
#define IN_OFF 0

static NSString * const CellIdentifier = @"ReportGoingCell";
static NSString * const LoadMoreCellIdentifier = @"LoadMoreCell";


@interface CheckMaterialPurchaseUndealTVC (){
    NSUInteger _page;
    NSMutableArray* _undealMaterialsList;
    BOOL _noMoreData;
}


@end

@implementation CheckMaterialPurchaseUndealTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _undealMaterialsList = [NSMutableArray array];
    
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
    return _undealMaterialsList.count > 0? _undealMaterialsList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < _undealMaterialsList.count){
        ReportGoingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        AuditMaterialsVO* auditMaterials = [_undealMaterialsList objectAtIndex:indexPath.row];
        
        UserShortVO* userShortVO = [auditMaterials user];
        NSString* userName = [userShortVO name];
        
        MyGroup* group = [auditMaterials group];
        NSString* role = [group name];
        
        [cell configureCellWithTitle:[auditMaterials name] withTime:[auditMaterials time] withUsername:userName withRole:role withDetail:[auditMaterials detail] withPrice:[auditMaterials money]];
        
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
    if(indexPath.row < _undealMaterialsList.count){
        ReportMaterialDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportMaterialDetailTVC"];
        [detail setAuditMaterialsVO:[_undealMaterialsList objectAtIndex:indexPath.row]];
        detail.delegate = (id<CheckUpdateProtocol>)self.parentViewController.parentViewController;
        [detail.navigationItem setTitle:@"审核建材买入"];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadUndealedMaterialList:++_page];
    }
}

#pragma mark load data
- (void)loadUndealedMaterialList:(NSInteger)page{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[userData objectForKey:@"user_id"]integerValue];
    
    if(page <= 1){
        [_undealMaterialsList removeAllObjects];
    }
    
    [[NetworkManager sharedInstance]getAuditMaterialsListWithStatus:UNDEALSTATUS withIn_off:IN_OFF withPage:page withUserId:user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* auditMaterialsVOList = [response objectForKey:@"auditMaterialsVOList"];
            
            if(auditMaterialsVOList.count > 0){
                for(NSDictionary* dict in auditMaterialsVOList){
                    AuditMaterialsVO* auditMaterialsVO = [[AuditMaterialsVO alloc]initWithDictionary:dict error:nil];
                    [_undealMaterialsList addObject:auditMaterialsVO];
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
    [self loadUndealedMaterialList:_page];
}


@end
