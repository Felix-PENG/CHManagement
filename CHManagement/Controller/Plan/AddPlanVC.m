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
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MBProgressHUD+Extends.h"
#import "ErrorHandler.h"

@interface AddPlanVC ()

@end

@implementation AddPlanVC
{
    YesterdayPlanTVC *_yesterdayPlanTVC;
    TodayPlanTVC *_todayPlanTVC;
    TomorrowPlanTVC *_tomorrowPlanTVC;
    TabbedScrollViewController *_tsvc;
    BOOL _isAddNew;
    NSInteger _user_id;
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
    
    if([self.todaySchedule isKindOfClass:[ScheduleVO class]]){
        _isAddNew = NO;
        [self.navigationItem setTitle:@"计划更新"];
    }else{
        _isAddNew = YES;
    }
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    _user_id = [[userData objectForKey:@"user_id"]integerValue];
    
    [self loadSchedule];
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
#pragma mark IBAction
- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender
{
    if(_isAddNew){
        [[NetworkManager sharedInstance]createScheduleWithYesterday:[_yesterdayPlanTVC summary] withToday:[_todayPlanTVC arrangement] withTomorrow:[_tomorrowPlanTVC plan] withUserId:_user_id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            NSLog(@"%lu",[resultVO success]);
            if([resultVO success] == 0){
                [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }else{
        [[NetworkManager sharedInstance]changeScheduleWithId:[self.todaySchedule id] withYesterday:[_yesterdayPlanTVC summary] withToday:[_todayPlanTVC arrangement] withTomorrow:[_tomorrowPlanTVC plan] completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            
            if([resultVO success] == 0){
                [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark load data
- (void)loadSchedule{
    if(_isAddNew){  //计划添加
        [[NetworkManager sharedInstance]getYesterdayScheduleByUserId:_user_id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];

            if([resultVO success] == 0){
                ScheduleVO* yesterdaySchedule = [[ScheduleVO alloc]initWithDictionary:[response objectForKey:@"scheduleVO"] error:nil];

                _yesterdayPlanTVC.arrangement = [yesterdaySchedule today];
                _todayPlanTVC.plan = [yesterdaySchedule tomorrow];
            }
        }];
    }else{  //计划更新
        _yesterdayPlanTVC.summary = [self.todaySchedule yesterday];
        _todayPlanTVC.arrangement = [self.todaySchedule today];
        _tomorrowPlanTVC.plan = [self.todaySchedule tomorrow];
        
        NSDate *todayScheduleDate = [[NSDate alloc] initWithTimeIntervalSince1970:self.todaySchedule.time/1000.0];
        BOOL isToday = [[NSCalendar currentCalendar]isDateInToday:todayScheduleDate];
        if(!isToday){
            [_yesterdayPlanTVC setSummaryTextViewEditable:NO];
            [_todayPlanTVC setArrangementTextViewEditable:NO];
            [_tomorrowPlanTVC setPlanTextViewEditable:NO];
            [self.navigationItem setRightBarButtonItem:nil];
        }

        [[NetworkManager sharedInstance]getYesterdayScheduleById:[self.todaySchedule id] completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            
            if([resultVO success] == 0){
                ScheduleVO* yesterdaySchedule = [[ScheduleVO alloc]initWithDictionary:[response objectForKey:@"scheduleVO"] error:nil];
                
                _yesterdayPlanTVC.arrangement = [yesterdaySchedule today];
                _todayPlanTVC.plan = [yesterdaySchedule tomorrow];
            }
        }];
    }
}

@end
