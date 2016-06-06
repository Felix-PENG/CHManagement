//
//  RegisterViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterViewController.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MyGroup.h"
#import "UserInfo.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    UIAlertController *_sheetAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([UserInfo sharedInstance].groupId == 0) {
        _sheetAlert = [UIAlertController alertControllerWithTitle:@"选择部门" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        // get groups
        [[NetworkManager sharedInstance] getAllGroupsWithCompletionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];;
            
            if([resultVO success] == 0){
                NSArray* groupList = [response objectForKey:@"groupList"];
                for(NSDictionary* groupDict in groupList){
                    MyGroup* group = [[MyGroup alloc]initWithDictionary:groupDict error:nil];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:group.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        self.groupID = group.id;
                    }];
                    [_sheetAlert addAction:action];
                }
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [_sheetAlert addAction:cancelAction];
            }
        }];
        // navigation items
        UIBarButtonItem *roleItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_assignment_ind_white_24dp"] style:UIBarButtonItemStylePlain target:self action:@selector(roleButtonPressed)];
        self.navigationItem.rightBarButtonItems = [[NSArray arrayWithArray:[self rightNavigationItems]] arrayByAddingObject:roleItem];
    } else {
        self.navigationItem.rightBarButtonItems = [self rightNavigationItems];
    }
}
- (IBAction)registerButtonPressed:(id)sender {
}

- (void)roleButtonPressed
{
    [self showSheet];
}

- (void)showSheet
{
    [self presentViewController:_sheetAlert animated:YES completion:nil];
}

#pragma mark - To be implemented

- (NSArray *)rightNavigationItems
{
    return nil;
}

@end
