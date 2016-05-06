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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"建材买入列表";
    
    // contents
    BuildingMaterialPurchaseGoingTVC *rfgtvc = [[BuildingMaterialPurchaseGoingTVC alloc] init];
    BuildingMaterialPurchaseDoneTVC *rfdtvc = [[BuildingMaterialPurchaseDoneTVC alloc] init];
    
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
