//
//  ReportFundsVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportFundsVC.h"
#import "TabbedScrollViewController.h"
#import "ReportFundsGoingTVC.h"
#import "ReportFundsRejectedTVC.h"
#import "TabItem.h"
#import "ReportRegisterTVC.h"

@interface ReportFundsVC ()

@end

@implementation ReportFundsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // title
    self.navigationItem.title = @"经费审核情况";
    
    // contents
    ReportFundsGoingTVC *rfgtvc = [[ReportFundsGoingTVC alloc] init];
    ReportFundsRejectedTVC *rfrtvc = [[ReportFundsRejectedTVC alloc] init];
    
    TabItem *item1 = [[TabItem alloc] initWithTab:@"进行中" controller:rfgtvc];
    TabItem *item2 = [[TabItem alloc] initWithTab:@"被驳回" controller:rfrtvc];
    
    TabbedScrollViewController *tsvc = [[TabbedScrollViewController alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) items:@[item1, item2]];
    
    [self.view addSubview:tsvc.view];
    [self addChildViewController:tsvc];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // bar button items
    UIBarButtonItem *roleItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_assignment_ind_white_24dp"] style:UIBarButtonItemStylePlain target:self action:@selector(roleButtonPressed)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    self.navigationItem.rightBarButtonItems = @[addItem, roleItem];
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

- (void)roleButtonPressed
{
    
}

- (void)addButtonPressed
{
    ReportRegisterTVC *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportRegisterTVC"];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
