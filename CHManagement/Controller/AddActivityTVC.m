//
//  AddActivityTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/30.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AddActivityTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MBProgressHUD+Extends.h"

@interface AddActivityTVC (){
    NSInteger group_id;
    NSInteger user_id;
}

@property (nonatomic,assign)IBOutlet UITextView* yesterdayTextView;

@property (nonatomic,assign)IBOutlet UITextView* todayTextView;

@end

@implementation AddActivityTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[self.view tintColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    group_id = [[userData objectForKey:@"group_id"]integerValue];
    user_id = [[userData objectForKey:@"user_id"]integerValue];
    
    if ([self.activity isKindOfClass:[ActivityVO class]]) {
        self.navigationItem.title = @"活动更新";
        _todayTextView.text = _activity.detail;
        
        NSDate *activityDate = [[NSDate alloc] initWithTimeIntervalSince1970:_activity.time/1000.0];
        BOOL isToday = [[NSCalendar currentCalendar]isDateInToday:activityDate];
        if(!isToday){
            _todayTextView.editable = NO;
            self.navigationItem.rightBarButtonItem = nil;
        }
    }else{
        _todayTextView.text = @"";
    }
    
    [self loadYesterdayActivity];
    _yesterdayTextView.editable = NO;
}

#pragma mark IBAction
- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender
{
    if([self.activity isKindOfClass:[ActivityVO class]]){
        [[NetworkManager sharedInstance]changeActivityWithActivityId:self.activity.id withContent:_todayTextView.text withUserId:user_id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            if([resultVO success] == 0){
                [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                [self showErrorAlert:[resultVO message]];
            }
        }];
    }else{
        [[NetworkManager sharedInstance]createActivityWithGroupId:group_id withContent:_todayTextView.text withUserId:user_id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            if([resultVO success] == 0){
                [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                [self showErrorAlert:[resultVO message]];
            }
        }];
    }
}

- (void)showErrorAlert:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark load data
- (void)loadYesterdayActivity{
    if([self.activity isKindOfClass:[ActivityVO class]]){
        NSInteger activity_id = _activity.id;
        [[NetworkManager sharedInstance]getYesterdayActivityWithGroupId:group_id withActivityId:activity_id completionHandler:^(NSDictionary *response) {
            ActivityVO* yesterdayActivity = [[ActivityVO alloc]initWithDictionary:[response objectForKey:@"activityVO"] error:nil];
            if(yesterdayActivity){
                _yesterdayTextView.text = yesterdayActivity.detail;
            }else{
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                _yesterdayTextView.text = resultVO.message;
            }
        }];
    }else{
        [[NetworkManager sharedInstance]getYesterdayActivityByGroupId:group_id completionHandler:^(NSDictionary *response) {
            ActivityVO* yesterdayActivity = [[ActivityVO alloc]initWithDictionary:[response objectForKey:@"activityVO"] error:nil];
            if(yesterdayActivity){
                _yesterdayTextView.text = yesterdayActivity.detail;
            }else{
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                _yesterdayTextView.text = resultVO.message;
            }
        }];
    }
}

@end
