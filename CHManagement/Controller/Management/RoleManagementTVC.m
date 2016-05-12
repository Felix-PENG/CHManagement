//
//  RoleManagementTVC.m
//  CHManagement
//
//  Created by Peng, Troy on 5/11/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "RoleManagementTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "Role.h"
#import "ErrorHandler.h"
#import "AddRoleTVC.h"

static NSString* const CellIdentifier = @"RoleCell";

@implementation RoleManagementTVC{
    NSMutableArray* _roleList;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _roleList = [NSMutableArray array];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _roleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [[_roleList objectAtIndex:indexPath.row]name];
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddRoleTVC *addRoleTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddRoleTVC"];
    [addRoleTVC setRole:[_roleList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:addRoleTVC animated:YES];
}

#pragma mark load data
- (void)loadAllRoles{
    [_roleList removeAllObjects];
    
    [[NetworkManager sharedInstance]getRolesWithCompletionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* roleList = [response objectForKey:@"roleList"];
            
            for(NSDictionary* roleDict in roleList){
                Role* role = [[Role alloc]initWithDictionary:roleDict error:nil];
                [_roleList addObject:role];
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
    [self loadAllRoles];
}

#pragma mark IBAction
- (IBAction)addButtonPressed:(id)sender{
    AddRoleTVC *addRoleTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddRoleTVC"];
    [self.navigationController pushViewController:addRoleTVC animated:YES];
}

@end
