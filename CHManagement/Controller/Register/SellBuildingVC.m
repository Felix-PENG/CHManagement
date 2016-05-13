//
//  SellBuildingVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "SellBuildingVC.h"
#import "SellBuildingTVC.h"
#import "AddSellBuildingTVC.h"

@interface SellBuildingVC ()

@end

@implementation SellBuildingVC
{
    SellBuildingTVC *_tvc;
}

- (void)setGroupID:(NSInteger)groupID
{
    _tvc.groupID = groupID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"建材卖出列表";
    
    _tvc = [[SellBuildingTVC alloc] init];
    _tvc.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [self.view addSubview:_tvc.view];
    [self addChildViewController:_tvc];
}

- (NSArray *)rightNavigationItems
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    return @[addItem];
}

- (void)addButtonPressed
{
    AddSellBuildingTVC *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddSellBuildingTVC"];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
