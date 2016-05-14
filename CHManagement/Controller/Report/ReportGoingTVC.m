//
//  ReportGoingTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportGoingTVC.h"

@interface ReportGoingTVC ()

@end

@implementation ReportGoingTVC

- (NSString *)cellIdentifier
{
    return @"ReportGoingCell";
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

@end
