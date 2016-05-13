//
//  UserManagementTVC.m
//  CHManagement
//
//  Created by Peng, Troy on 5/11/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "UserManagementTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "UserVO.h"
#import "ErrorHandler.h"
#import "AddUserTVC.h"

static NSString* const CellIdentifier = @"UserCell";

@implementation UserManagementTVC{
    NSMutableArray* _userList;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _userList = [NSMutableArray array];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [[_userList objectAtIndex:indexPath.row]name];
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddUserTVC *addUserTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddUserTVC"];
    [addUserTVC setUserVO:[_userList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:addUserTVC animated:YES];
}

#pragma mark load data
- (void)loadAllUsers{
    [_userList removeAllObjects];
    
    [[NetworkManager sharedInstance]getUsersWithCompletionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* userVOList = [response objectForKey:@"userVOList"];
            
            for(NSDictionary* userDict in userVOList){
                UserVO* user = [[UserVO alloc]initWithDictionary:userDict error:nil];
                [_userList addObject:user];
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
    [self loadAllUsers];
}

#pragma mark IBAction
- (IBAction)addButtonPressed:(id)sender{
    AddUserTVC *addUserTVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddUserTVC"];
    [self.navigationController pushViewController:addUserTVC animated:YES];
}

@end
