//
//  CheckMaterialPurchaseVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "CheckMaterialPurchaseVC.h"
#import "CheckMaterialPurchaseUndealTVC.h"
#import "CheckMaterialPurchaseDealedTVC.h"
#import "TabItem.h"
#import "TabbedScrollViewController.h"

@interface CheckMaterialPurchaseVC ()

@end

@implementation CheckMaterialPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"审核建材买入";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // contents
    CheckMaterialPurchaseUndealTVC *rfgtvc = [[CheckMaterialPurchaseUndealTVC alloc] init];
    CheckMaterialPurchaseDealedTVC *rfdtvc = [[CheckMaterialPurchaseDealedTVC alloc] init];
    
    TabItem *tabItem1 = [[TabItem alloc] initWithTab:@"未处理" controller:rfgtvc];
    TabItem *tabItem2 = [[TabItem alloc] initWithTab:@"已处理" controller:rfdtvc];
    
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
