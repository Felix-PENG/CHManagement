//
//  ReportRejectedTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportRejectedTVC.h"

@interface ReportRejectedTVC ()

@end

@implementation ReportRejectedTVC

- (NSString *)cellIdentifier
{
    return @"ReportRejectedCell";
}

- (NSString *)loadMoreCellIdentifier
{
    return @"LoadMoreCell";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:self.cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:self.cellIdentifier];
    
    nib = [UINib nibWithNibName:self.loadMoreCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:self.loadMoreCellIdentifier];
}

- (void)refresh
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
