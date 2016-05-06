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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"经费列表";
    
    // contents
    RegisterFundsGoingTVC *rfgtvc = [[RegisterFundsGoingTVC alloc] init];
    RegisterFundsDoneTVC *rfdtvc = [[RegisterFundsDoneTVC alloc] init];
    
    TabItem *tabItem1 = [[TabItem alloc] initWithTab:@"进行中" controller:rfgtvc];
    TabItem *tabItem2 = [[TabItem alloc] initWithTab:@"已完成" controller:rfdtvc];
    
    TabbedScrollViewController *tsvc = [[TabbedScrollViewController alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) items:@[tabItem1, tabItem2]];
    [self.view addSubview:tsvc.view];
    [self addChildViewController:tsvc];
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
