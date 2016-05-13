//
//  AddRoleTVC.m
//  CHManagement
//
//  Created by Peng, Troy on 5/12/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "AddRoleTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MBProgressHUD+Extends.h"
#import "ErrorHandler.h"
#import "Permission.h"
#import "RoleCell.h"
#import "RoleManagementTVC.h"

static NSString* const RoleCellIdentifier = @"RoleCell";
static NSString* const PermissionCellIdentifier = @"PermissionCell";

@implementation AddRoleTVC{
    NSMutableArray* _permissionList;
    NSMutableArray* _rolePermissionList;
}

#pragma mark life cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:RoleCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:RoleCellIdentifier];
    
    _permissionList = [NSMutableArray array];
    _rolePermissionList = [NSMutableArray array];

    [self loadAllPermissions];
    if(self.role){
        [self loadRolePermission];
        [self.navigationItem setTitle:@"角色信息更新"];
    }
    
}

#pragma mark IBAction
- (IBAction)saveButtonPressed:(id)sender{
    RoleCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString* roleName = cell.roleNameField.text;
    
    if([roleName isEqualToString:@""]){
        UIAlertController* alert = [ErrorHandler showErrorAlert:@"角色名不得为空"];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSMutableString* idList = [NSMutableString stringWithString:@"["];
        
        for(Permission* permission in _rolePermissionList){
            [idList appendFormat:@"%@,",[NSNumber numberWithInteger:[permission id]]];
        }
        
        [idList deleteCharactersInRange:NSMakeRange([idList length]-1, 1)];
        [idList appendString:@"]"];
        
        if(self.role){
            //修改角色名
            [[NetworkManager sharedInstance]changeRoleWithRoleId:self.role.id withName:roleName completionHandler:^(NSDictionary *response) {
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                
                if(resultVO.success == 0){
                    //修改权限
                    [[NetworkManager sharedInstance]changeRolePermissionWithRoleId:self.role.id withPermissionList:idList completionHandler:^(NSDictionary *response) {
                        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                        
                        if(resultVO.success == 0){
                            [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                                RoleManagementTVC* roleManagementTVC = (RoleManagementTVC*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                                [roleManagementTVC setRepeatLoad:NO];
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                        }else{
                            UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    }];
                }else{
                    UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }else{
            [[NetworkManager sharedInstance] createRoleAndPermissionWithName:roleName withPermissionList:idList completionHandler:^(NSDictionary *response) {
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                    
                if(resultVO.success == 0){
                    [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                        RoleManagementTVC* roleManagementTVC = (RoleManagementTVC*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                        [roleManagementTVC setRepeatLoad:NO];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }else{
                    UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return _permissionList.count;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"角色名";
    }else{
        return @"权限分配";
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        RoleCell* cell = [self.tableView dequeueReusableCellWithIdentifier:RoleCellIdentifier];
        if(self.role){
            [cell configureCell:self.role.name];
        }
        return cell;
    }else{
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:PermissionCellIdentifier];
        Permission* currentPermission = [_permissionList objectAtIndex:indexPath.row];
        cell.textLabel.text = currentPermission.name;
        if(self.role){
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            for(Permission* permission in _rolePermissionList){
                if(permission.id == currentPermission.id){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    break;
                }
            }
        }
        return cell;
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        
        Permission* permission = [_permissionList objectAtIndex:indexPath.row];
        if(cell.accessoryType ==  UITableViewCellAccessoryCheckmark){
            [_rolePermissionList addObject:permission];
        }else{
            for(Permission* singlePermission in _rolePermissionList){
                if([singlePermission id] == [permission id]){
                    [_rolePermissionList removeObject:singlePermission];
                    break;
                }
            }
        }
    }
}

#pragma load data
- (void)loadAllPermissions{
    [_permissionList removeAllObjects];
    [[NetworkManager sharedInstance]getPermissionsWithCompletionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if(resultVO.success == 0){
            NSArray* permissionList = [response objectForKey:@"permissionList"];
            
            for(NSDictionary* dict in permissionList){
                Permission* permission = [[Permission alloc]initWithDictionary:dict error:nil];
                [_permissionList addObject:permission];
            }
            [self.tableView reloadData];
        }else{
            UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)loadRolePermission{
    [_rolePermissionList removeAllObjects];

    [[NetworkManager sharedInstance]getRolePermissionWithRoleId:self.role.id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if(resultVO.success == 0){
            NSArray* permissionList = [response objectForKey:@"permissionList"];
            
            for(NSDictionary* dict in permissionList){
                Permission* permission = [[Permission alloc]initWithDictionary:dict error:nil];
                [_rolePermissionList addObject:permission];
            }
            [self.tableView reloadData];
        }else{
            UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

@end
