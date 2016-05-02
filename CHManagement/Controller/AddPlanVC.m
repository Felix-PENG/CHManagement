//
//  AddPlanVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AddPlanVC.h"
#import "TabbedScrollViewController.h"
#import "TabItem.h"
#import "YesterdayPlanTVC.h"
#import "TodayPlanTVC.h"
#import "TomorrowPlanTVC.h"

@interface AddPlanVC ()

@end

@implementation AddPlanVC
{
    YesterdayPlanTVC *_yesterdayPlanTVC;
    TodayPlanTVC *_todayPlanTVC;
    TomorrowPlanTVC *_tomorrowPlanTVC;
    TabbedScrollViewController *_tsvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:[self.view tintColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // add subviews
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _yesterdayPlanTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YesterdayPlanTVC"];
    _todayPlanTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TodayPlanTVC"];
    _tomorrowPlanTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TomorrowPlanTVC"];
    
    
    TabItem *yesItem = [[TabItem alloc] initWithTab:_yesterdayPlanTVC.title controller:_yesterdayPlanTVC];
    TabItem *todItem = [[TabItem alloc] initWithTab:_todayPlanTVC.title controller:_todayPlanTVC];
    TabItem *tomoItem = [[TabItem alloc] initWithTab:_tomorrowPlanTVC.title controller:_tomorrowPlanTVC];
    
    _tsvc = [[TabbedScrollViewController alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) items:@[yesItem, todItem, tomoItem]];
    [self.view addSubview:_tsvc.view];
    [self addChildViewController:_tsvc];
    
//    [self.view addSubview:_yesterdayPlanTVC.view];
//    [self addChildViewController:_yesterdayPlanTVC];
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
- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
