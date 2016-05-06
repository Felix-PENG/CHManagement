//
//  ReportMaterialRejectedTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportMaterialRejectedTVC.h"
#import "ReportRejectedCell.h"
#import "ReportRegisterTVC.h"
#import "ReportDetailTVC.h"

@interface ReportMaterialRejectedTVC () <ReportRejectedDelegate>

@end

@implementation ReportMaterialRejectedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

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
    ReportRejectedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    [cell setOffsetTag:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportDetailTVC *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportDetailTVC"];
    
    [self.navigationController pushViewController:detail animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ReportRejectedDelegate

- (void)modifyButtonPressed:(NSUInteger)index
{
    ReportRejectedTVC *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportRegisterTVC"];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
