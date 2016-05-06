//
//  ChooseUserTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/3.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ChooseUserTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "UserVO.h"
#import "SendMailTVC.h"

@interface ChooseUserTVC ()

@end

@implementation ChooseUserTVC{
    NSMutableArray* _userList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userList = [NSMutableArray array];
    
    [self loadAllUser];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    UserVO* user = [_userList objectAtIndex:indexPath.row];
    
    for(UserVO* singleUser in self.choosedUserList){
        if([singleUser id] == [user id]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    
    cell.textLabel.text = [[_userList objectAtIndex:indexPath.row]name];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
    UserVO* user = [_userList objectAtIndex:indexPath.row];
    if(cell.accessoryType ==  UITableViewCellAccessoryCheckmark){
        [self.choosedUserList addObject:user];
    }else{
        for(UserVO* singleUser in self.choosedUserList){
            if([singleUser id] == [user id]){
                [self.choosedUserList removeObject:singleUser];
                break;
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark IBAction
- (IBAction)confirmButtonPressed:(id)sender{
    SendMailTVC* sendMailViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    [sendMailViewController setReceivers:self.choosedUserList];
    [self.navigationController popToViewController:sendMailViewController animated:true];
}

#pragma mark load data
- (void)loadAllUser{
    [[NetworkManager sharedInstance]getUsersWithCompletionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];

        if([resultVO success] == 0){
            NSArray* userVOList = [response objectForKey:@"userVOList"];
            for(NSDictionary* userDict in userVOList){
                [_userList addObject:[[UserVO alloc]initWithDictionary:userDict error:nil]];
            }
            [self.tableView reloadData];
            
        }else{
            //error handler
        }
    }];
}

@end
