//
//  GroupManagementTVC.m
//  CHManagement
//
//  Created by Peng, Troy on 5/11/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "GroupManagementTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MyGroup.h"
#import "ErrorHandler.h"

static NSString * const CellIdentifier = @"GroupCell";

@implementation GroupManagementTVC{
    NSMutableArray* _groupList;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _groupList = [NSMutableArray array];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [[_groupList objectAtIndex:indexPath.row]name];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //ReportDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportDetailTVC"];
        //[detail setAuditOthersVO:[_goingAuditOthersList objectAtIndex:indexPath.row]];
        //[detail setCheckable:NO];
        //[self.navigationController pushViewController:detail animated:YES];
}

#pragma mark load data
- (void)loadAllGroups{
    [_groupList removeAllObjects];
    
    [[NetworkManager sharedInstance]getAllGroupsWithCompletionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* groupList = [response objectForKey:@"groupList"];
            
            for(NSDictionary* groupDict in groupList){
                MyGroup* group = [[MyGroup alloc]initWithDictionary:groupDict error:nil];
                [_groupList addObject:group];
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
    [self loadAllGroups];
}


@end
