//
//  AddActivityTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/30.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AddActivityTVC.h"
#import "NetworkManager.h"

@interface AddActivityTVC ()

@property (nonatomic,assign)IBOutlet UITextView* yesterdayTextView;

@property (nonatomic,assign)IBOutlet UITextView* todayTextView;

@end

@implementation AddActivityTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[self.view tintColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if (self.activity) {
        self.navigationItem.title = @"活动更新";
        _todayTextView.text = _activity.detail;
    }
    [self loadYesterdayActivity];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveButtonPressed:(id)sender
{
    
}

- (void)loadYesterdayActivity{
    NSInteger group_id = 0;//need to override here
    NSInteger activity_id = _activity.id;
    [[NetworkManager sharedInstance]getYesterdayActivityWithGroupId:group_id withActivityId:activity_id completionHandler:^(NSDictionary *response) {
        ActivityVO* yesterdayActivity = [[ActivityVO alloc]initWithDictionary:[response objectForKey:@"activityVO"] error:nil];
        _yesterdayTextView.text = yesterdayActivity.detail;
        _yesterdayTextView.editable = NO;
    }];
}

@end
