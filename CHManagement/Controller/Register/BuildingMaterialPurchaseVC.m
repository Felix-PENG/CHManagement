//
//  BuildingMaterialPurchaseVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "BuildingMaterialPurchaseVC.h"
#import "BuildingMaterialPurchaseGoingTVC.h"
#import "BuildingMaterialPurchaseDoneTVC.h"
#import "TabItem.h"
#import "TabbedScrollViewController.h"

@interface BuildingMaterialPurchaseVC ()

@end

@implementation BuildingMaterialPurchaseVC
{
    BuildingMaterialPurchaseGoingTVC *_rfgtvc;
    BuildingMaterialPurchaseDoneTVC *_rfdtvc;
}

- (void)setGroupID:(NSInteger)groupID
{
    _rfgtvc.groupID = groupID;
    _rfdtvc.groupID = groupID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"建材买入列表";
    
    // contents
    _rfgtvc = [[BuildingMaterialPurchaseGoingTVC alloc] init];
    _rfdtvc = [[BuildingMaterialPurchaseDoneTVC alloc] init];
    
    TabItem *tabItem1 = [[TabItem alloc] initWithTab:@"进行中" controller:_rfgtvc];
    TabItem *tabItem2 = [[TabItem alloc] initWithTab:@"已完成" controller:_rfdtvc];
    
    TabbedScrollViewController *tsvc = [[TabbedScrollViewController alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) items:@[tabItem1, tabItem2]];
    [self.view addSubview:tsvc.view];
    [self addChildViewController:tsvc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AddBuildingMaterialsDelegate

- (void)needRefresh
{
    _rfgtvc.repeatLoad = NO;
    _rfdtvc.repeatLoad = NO;
}

@end
