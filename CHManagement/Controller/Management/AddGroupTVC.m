//
//  AddGroupTVC.m
//  CHManagement
//
//  Created by Peng, Troy on 5/12/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "AddGroupTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MBProgressHUD+Extends.h"
#import "ErrorHandler.h"
#import "GroupManagementTVC.h"

@interface AddGroupTVC()

@property (nonatomic, weak) IBOutlet UITextField* groupNameField;

@end

@implementation AddGroupTVC

- (void)viewDidLoad{
    [super viewDidLoad];
    if(self.group){
        self.groupNameField.text = self.group.name;
        self.navigationItem.title = @"部门信息更新";
    }
}

- (IBAction)saveButtonPressed:(id)sender{
    if([self.groupNameField.text isEqualToString:@""]){
        UIAlertController* alert = [ErrorHandler showErrorAlert:@"部门名不得为空"];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if(self.group){
            if([self.groupNameField.text isEqualToString:self.group.name]){
                UIAlertController* alert = [ErrorHandler showErrorAlert:@"与原部门名相同"];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [[NetworkManager sharedInstance] changeGroupName:self.groupNameField.text withGroupId:self.group.id completionHandler:^(NSDictionary *response) {
                    ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                    
                    if(resultVO.success == 0){
                        [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                            GroupManagementTVC* groupManagementTVC = (GroupManagementTVC*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                            [groupManagementTVC setRepeatLoad:NO];
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }else{
                        UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }
        }else{
            [[NetworkManager sharedInstance]createGroupWithName:self.groupNameField.text completionHandler:^(NSDictionary *response) {
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                
                if(resultVO.success == 0){
                    [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                        GroupManagementTVC* groupManagementTVC = (GroupManagementTVC*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                        [groupManagementTVC setRepeatLoad:NO];
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

@end
