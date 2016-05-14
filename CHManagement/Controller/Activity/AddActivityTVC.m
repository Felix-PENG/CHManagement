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
#import "ErrorHandler.h"
#import "ActivityTVC.h"
#import "UserInfo.h"

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
    
    group_id = [UserInfo sharedInstance].groupId;
    user_id = [UserInfo sharedInstance].id;
    
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
                UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                [self presentViewController:alert animated:YES completion:nil];
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
                UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
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
