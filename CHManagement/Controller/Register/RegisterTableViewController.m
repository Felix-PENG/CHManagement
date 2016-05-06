//
//  RegisterTableViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "RegisterCell.h"

@interface RegisterTableViewController ()

@end

@implementation RegisterTableViewController

- (NSString *)cellIdentifier
{
    return @"RegisterCell";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINib *nib = [UINib nibWithNibName:self.cellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:self.cellIdentifier];
}

- (void)refresh
{
    
}

@end
