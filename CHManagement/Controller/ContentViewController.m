//
//  ContentViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/27.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ContentViewController.h"
#import "MainViewController.h"
#import "NetworkManager.h"
#import "Constants.h"
#import "Permission.h"
#import "ReportFundsVC.h"
#import "ReportMaterialVC.h"

#define SECTION_HEADER_HEIGHT 28.0
#define TOP_MENU_CELL_HEIGHT 84.0
#define CELL_HEIGHT 44.0

@interface ContentViewController ()

@end

@implementation ContentViewController
{
    NSMutableDictionary *_permissionDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[self.view tintColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    _permissionDict = [NSMutableDictionary dictionary];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _permissionDict.allKeys.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return ((NSArray *)_permissionDict[_permissionDict.allKeys[section - 1]]).count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [self.tableView dequeueReusableCellWithIdentifier:@"TopMenuCell"];
    } else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.textLabel.text = ((Permission *)((NSArray *)_permissionDict[_permissionDict.allKeys[indexPath.section - 1]])[indexPath.row]).name;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, SECTION_HEADER_HEIGHT)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 50, headerView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor lightGrayColor];
        label.text = _permissionDict.allKeys[section - 1];
        [headerView addSubview:label];
        [headerView setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]];
        return headerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return TOP_MENU_CELL_HEIGHT;
    } else {
        return CELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return SECTION_HEADER_HEIGHT;
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (((Permission *)((NSArray *)_permissionDict[_permissionDict.allKeys[indexPath.section - 1]])[indexPath.row]).id) {
        case FundsReport:
            [self.navigationController pushViewController:[[ReportFundsVC alloc] init] animated:YES];
            break;
        case BuildingMaterialPurchaseReport:
            [self.navigationController pushViewController:[[ReportMaterialVC alloc] init] animated: YES];
            break;
        default:
            break;
    }
    
}

- (void)fetchPermissions
{
    [[NetworkManager sharedInstance] getRolePermissionWithRoleId:0 completionHandler:^(NSDictionary *response) {
        NSArray *permissionList = [response objectForKey:@"permissionList"];
        [self buildPermissionMapWithArray:permissionList];

        [self.tableView reloadData];
        
        if (self.refreshControl.isRefreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)buildPermissionMapWithArray:(NSArray *)array
{
    [_permissionDict removeAllObjects];
    
    for (NSDictionary *dict in array) {
        Permission *permission = [[Permission alloc] initWithDictionary:dict error:nil];
        
        for (NSString *sectionHead in [Constants kPermissionDictionary].allKeys) {
            NSArray *ids = [Constants kPermissionDictionary][sectionHead];
            if ([ids containsObject: @(permission.id)]) {
                if (!_permissionDict[sectionHead]) {
                    _permissionDict[sectionHead] = [NSMutableArray array];
                }
                [_permissionDict[sectionHead] addObject:permission];
                
                break;
            }
        }
    }
}

- (IBAction)refresh
{
    [self fetchPermissions];
}

#pragma mark - Jump

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)menuButtonPressed:(id)sender
{
    UIViewController *rootViewController = self.parentViewController.parentViewController;
    if ([rootViewController isKindOfClass:[MainViewController class]]) {
        [((MainViewController *)rootViewController) presentLeftMenuViewController];
    }
}

@end
