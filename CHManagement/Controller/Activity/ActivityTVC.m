//
//  ActivityTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/29.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ActivityTVC.h"
#import "ActivityCell.h"
#import "NetworkManager.h"
#import "MBProgressHUD+Extends.h"
#import "ResultVO.h"
#import "ActivityVO.h"
#import "AddActivityTVC.h"
#import "LoadMoreCell.h"
#import "MyGroup.h"
#import "UserInfo.h"

static NSString * const CellIdentifier = @"ActivityCell";
static NSString * const LoadMoreCellIdentifier = @"LoadMoreCell";
static NSString * const AddActivitySegue = @"AddActivity";

@interface ActivityTVC()

@property (nonatomic, weak) IBOutlet UIBarButtonItem* roleButtonItem;
@end

@implementation ActivityTVC
{
    UIAlertController *_sheetAlert;
    NSUInteger _page;
    NSMutableArray *_activityList;
    BOOL _noMoreData;
    NSNumber* _choosedGroupId;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    
    cellNib = [UINib nibWithNibName:LoadMoreCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LoadMoreCellIdentifier];
    
    NSInteger group_id = [UserInfo sharedInstance].groupId;
    
    if(group_id == 0){
        _sheetAlert = [UIAlertController alertControllerWithTitle:@"选择部门" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [[NetworkManager sharedInstance]getAllGroupsWithCompletionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];;
            
            if([resultVO success] == 0){
                NSArray* groupList = [response objectForKey:@"groupList"];
                for(NSDictionary* groupDict in groupList){
                    MyGroup* group = [[MyGroup alloc]initWithDictionary:groupDict error:nil];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:group.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        _choosedGroupId = [NSNumber numberWithInteger:group.id];
                        [self refresh];
                    }];
                    [_sheetAlert addAction:action];
                }
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_sheetAlert addAction:cancelAction];
    }else{
        NSMutableArray<UIBarButtonItem*>* buttonItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
        
        [buttonItems removeObject:self.roleButtonItem];
        
        [self.navigationItem setRightBarButtonItems:buttonItems];
    }
    
    _activityList = [NSMutableArray array];
    _page = 1;
    
    // cell自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 98.0;
}

- (void)viewDidDisappear:(BOOL)animated{
    self.repeatLoad = NO;
}

- (void)loadDataWithPage:(NSUInteger)page
{
    NSInteger group_id = [UserInfo sharedInstance].groupId;
    
    if(_choosedGroupId){
        group_id = _choosedGroupId.integerValue;
    }
    
    [[NetworkManager sharedInstance] getActivitiesByGroupId:group_id withPage:page completionHandler:^(NSDictionary *response) {
        
        if (page <= 1) {
            [_activityList removeAllObjects];
        }
        
        ResultVO *resultVO = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray *activityList = [response objectForKey:@"activityVOList"];
            
            if (activityList.count > 0) {
                for (NSDictionary *activityDict in activityList) {
                    [_activityList addObject:[[ActivityVO alloc] initWithDictionary:activityDict error:nil]];
                }
                _noMoreData = NO;
            } else {
                _noMoreData = YES;
            }
            
            [self.tableView reloadData];
            
        }else{
            NSLog(@"%@",[resultVO message]);
        }
        
        if (self.refreshControl.isRefreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)showSheet
{
    [self presentViewController:_sheetAlert animated:YES completion:nil];
}

#pragma mark - UITableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _activityList.count > 0 ? _activityList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _activityList.count) {
        ActivityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        ActivityVO *activity = [_activityList objectAtIndex:indexPath.row];
        
        [cell configureWithContent:activity.detail time:activity.time];
        
        return cell;
    } else {
        LoadMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
        cell.status = _noMoreData ? NoMore : ClickToLoad;
        return cell;
    }

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _activityList.count) {
        [self performSegueWithIdentifier:AddActivitySegue sender:[_activityList objectAtIndex:indexPath.row]];
    } else {
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadDataWithPage:++_page];
    }
}

#pragma mark - IBAction

- (IBAction)roolButtonPressed:(id)sender
{
    [self showSheet];
}

- (IBAction)refresh
{
    _page = 1;
    [self loadDataWithPage:_page];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:AddActivitySegue]) {
        UINavigationController *desViewController = segue.destinationViewController;
        if ([desViewController.topViewController isKindOfClass:[AddActivityTVC class]]) {
            ((AddActivityTVC *)desViewController.topViewController).activity = sender;
        }
    }
}


@end
