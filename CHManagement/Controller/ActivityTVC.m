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
#import "ActivityVO.h"
#import "AddActivityTVC.h"
#import "LoadMoreCell.h"

static NSString * const CellIdentifier = @"ActivityCell";
static NSString * const LoadMoreCellIdentifier = @"LoadMoreCell";
static NSString * const AddActivitySegue = @"AddActivity";

@interface ActivityTVC()

@end

@implementation ActivityTVC
{
    UIAlertController *_sheetAlert;
    NSUInteger _page;
    NSMutableArray *_activityList;
    BOOL _repeatLoad;
    BOOL _noMoreData;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *cellNib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    
    cellNib = [UINib nibWithNibName:@"LoadMoreCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LoadMoreCellIdentifier];
    
    _sheetAlert = [UIAlertController alertControllerWithTitle:@"选择角色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *adminAction = [UIAlertAction actionWithTitle:@"管理员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *managerAction = [UIAlertAction actionWithTitle:@"项目经理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *headAction = [UIAlertAction actionWithTitle:@"主任" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [_sheetAlert addAction:adminAction];
    [_sheetAlert addAction:managerAction];
    [_sheetAlert addAction:headAction];
    [_sheetAlert addAction:cancelAction];
    
    _activityList = [NSMutableArray array];
    _page = 1;
    
    // cell自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 98.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!_repeatLoad) {
        [self.refreshControl beginRefreshing];
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        _repeatLoad = YES;
    }
}

- (void)loadDataWithPage:(NSUInteger)page
{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger group_id = [[userData objectForKey:@"group_id"]integerValue];
    [[NetworkManager sharedInstance] getActivitiesByGroupId:group_id withPage:page completionHandler:^(NSDictionary *response) {
        
        if (page <= 1) {
            [_activityList removeAllObjects];
        }
        
        NSArray *activityList = [response objectForKey:@"activityVOList"];
//        ResultVO *resultVO = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if (activityList.count > 0) {
            for (NSDictionary *activityDict in activityList) {
                [_activityList addObject:[[ActivityVO alloc] initWithDictionary:activityDict error:nil]];
            }
        } else {
            _noMoreData = YES;
        }
        
        [self.tableView reloadData];
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
    
    [self.refreshControl endRefreshing];
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
