//
//  RegisterFundsVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterFundsVC.h"
#import "RegisterFundsDoneTVC.h"
#import "RegisterFundsGoingTVC.h"
#import "TabbedScrollViewController.h"
#import "TabItem.h"

@interface RegisterFundsVC ()

@end

@implementation RegisterFundsVC
{
    RegisterFundsGoingTVC *_rfgtvc;
    RegisterFundsDoneTVC *_rfdtvc;
}

- (void)setGroupID:(NSInteger)groupID
{
    _rfgtvc.groupID = groupID;
    _rfdtvc.groupID = groupID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"经费列表";
    
    // contents
    _rfgtvc = [[RegisterFundsGoingTVC alloc] init];
    _rfdtvc = [[RegisterFundsDoneTVC alloc] init];
    
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
