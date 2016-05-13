//
//  AddUserTVC.m
//  CHManagement
//
//  Created by Peng, Troy on 5/12/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "AddUserTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MyGroup.h"
#import "Role.h"
#import "ErrorHandler.h"
#import "MBProgressHUD+Extends.h"
#import "UserManagementTVC.h"

@interface AddUserTVC()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField* nameField;
@property (nonatomic, weak) IBOutlet UITextField* accountField;
@property (nonatomic, weak) IBOutlet UITextField* pswdField;

@property (weak, nonatomic) IBOutlet UIPickerView *groupPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *rolePicker;

@end

@implementation AddUserTVC{
    NSMutableArray* _allGroups;
    NSMutableArray* _allRoles;
    MyGroup* _selectedGroup;
    Role* _selectedRole;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _allGroups = [NSMutableArray array];
    _allRoles = [NSMutableArray array];
    
    [self loadAllData];
    self.groupPicker.delegate = self;
    self.groupPicker.dataSource = self;
    self.rolePicker.delegate = self;
    self.rolePicker.dataSource = self;
    
    if(self.userVO){
        [self.navigationItem setTitle:@"用户信息更新"];
        self.nameField.text = self.userVO.name;
        self.accountField.text = self.userVO.account.name;
        [self.accountField setEnabled:NO];
        [self.pswdField setEnabled:NO];
    }

}

#pragma mark UIPickerView datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual:self.groupPicker]){
        return _allGroups.count;
    }else{
        return _allRoles.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:self.groupPicker]){
        return [[_allGroups objectAtIndex:row]name];
    }else{
        return [[_allRoles objectAtIndex:row]name];
    }
}

#pragma mark UIPickerView delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if([pickerView isEqual:self.groupPicker]){
        _selectedGroup = [_allGroups objectAtIndex:row];
    }else{
        _selectedRole = [_allRoles objectAtIndex:row];
    }
}

#pragma load data
- (void)loadAllData{
    [_allGroups removeAllObjects];
    [_allRoles removeAllObjects];
    
    [[NetworkManager sharedInstance]getAllGroupsWithCompletionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if(resultVO.success == 0){
            NSArray* groupList = [response objectForKey:@"groupList"];
            for(NSDictionary* groupDict in groupList){
                MyGroup* group = [[MyGroup alloc]initWithDictionary:groupDict error:nil];
                [_allGroups addObject:group];
            }
            [self.groupPicker reloadAllComponents];
            for(int i = 0; i < _allGroups.count;i ++){
                MyGroup* thisGroup = [_allGroups objectAtIndex:i];
                if(thisGroup.id == self.userVO.group.id){
                    [self.groupPicker selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
        }else{
            UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    [[NetworkManager sharedInstance]getRolesWithCompletionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if(resultVO.success == 0){
            NSArray* roleList = [response objectForKey:@"roleList"];
            for(NSDictionary* roleDict in roleList){
                Role* role = [[Role alloc]initWithDictionary:roleDict error:nil];
                [_allRoles addObject:role];
            }
            [self.rolePicker reloadAllComponents];
            for(int i = 0; i < _allRoles.count;i ++){
                Role* thisRole = [_allRoles objectAtIndex:i];
                if(thisRole.id == self.userVO.role.id){
                    [self.rolePicker selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
        }else{
            UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark IBAction

- (IBAction)saveButtonPressed:(id)sender{
    if(self.userVO){
        [[NetworkManager sharedInstance]changeUserWithName:self.nameField.text withRoleId:_selectedRole.id withGroupId:_selectedGroup.id withUserId:self.userVO.id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            
            if(resultVO.success == 0){
                [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                    UserManagementTVC* userManagementTVC = (UserManagementTVC*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                    [userManagementTVC setRepeatLoad:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }else{
        [[NetworkManager sharedInstance]registerWithEmail:self.accountField.text withPswd:self.pswdField.text withName:self.nameField.text withRoleId:_selectedRole.id withGroupId:_selectedGroup.id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            
            if(resultVO.success == 0){
                [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                    UserManagementTVC* userManagementTVC = (UserManagementTVC*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                    [userManagementTVC setRepeatLoad:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    
}


@end
