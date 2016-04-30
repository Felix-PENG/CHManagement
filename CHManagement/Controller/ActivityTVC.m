//
//  ActivityTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/29.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ActivityTVC.h"
#import "ActivityCell.h"

static NSString * const CellIdentifier = @"ActivityCell";

@interface ActivityTVC() <UIActionSheetDelegate>

@end

@implementation ActivityTVC
{
    UIAlertController *_sheetAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *cellNib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    
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

- (void)showSheet
{
    [self presentViewController:_sheetAlert animated:YES completion:nil];
}

#pragma mark - UITableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98.0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"AddActivity" sender:nil];
}

#pragma mark - IBAction

- (IBAction)roolButtonPressed:(id)sender
{
    [self showSheet];
}

- (IBAction)refresh
{
    [self.refreshControl endRefreshing];
}


@end
