//
//  ReportMaterialVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportMaterialVC.h"
#import "TabbedScrollViewController.h"
#import "ReportMaterialGoingTVC.h"
#import "ReportMaterialRejectedTVC.h"
#import "TabItem.h"

@interface ReportMaterialVC ()

@end

@implementation ReportMaterialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"建材买入审核情况";
    
    ReportMaterialGoingTVC *rfgtvc = [[ReportMaterialGoingTVC alloc] init];
    ReportMaterialRejectedTVC *rfrtvc = [[ReportMaterialRejectedTVC alloc] init];
    
    TabItem *item1 = [[TabItem alloc] initWithTab:@"进行中" controller:rfgtvc];
    TabItem *item2 = [[TabItem alloc] initWithTab:@"被驳回" controller:rfrtvc];
    
    TabbedScrollViewController *tsvc = [[TabbedScrollViewController alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) items:@[item1, item2]];
    
    [self.view addSubview:tsvc.view];
    [self addChildViewController:tsvc];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
