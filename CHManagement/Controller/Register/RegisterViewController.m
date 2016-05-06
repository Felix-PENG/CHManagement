//
//  RegisterViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    UIAlertController *_sheetAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // navigation items
    UIBarButtonItem *roleItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_assignment_ind_white_24dp"] style:UIBarButtonItemStylePlain target:self action:@selector(roleButtonPressed)];
    self.navigationItem.rightBarButtonItems = [[NSArray arrayWithArray:[self rightNavigationItems]] arrayByAddingObject:roleItem];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
