//
//  AddActivityTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/30.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AddActivityTVC.h"
#import "NetworkManager.h"

@interface AddActivityTVC (){
    ActivityVO* yesterdayActivity;
    BOOL _repeatLoad;
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
    
    if (self.activity) {
        self.navigationItem.title = @"活动更新";
        _todayTextView.text = _activity.detail;
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.refreshControl beginRefreshing];
    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];

}

- (void)viewDidAppear:(BOOL)animated
{
    if (!_repeatLoad) {
        [self.refreshControl beginRefreshing];
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        _repeatLoad = YES;
    }
}

- (void)refresh
{
    [self loadYesterdayAndTodayActivity];
    [self.refreshControl endRefreshing];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveButtonPressed:(id)sender
{
    
}

- (void)loadYesterdayAndTodayActivity{
    NSInteger group_id = 0;//need to override here
    NSInteger activity_id = _activity.id;
    [[NetworkManager sharedInstance]getYesterdayActivityWithGroupId:group_id withActivityId:activity_id completionHandler:^(NSDictionary *response) {
        yesterdayActivity = [[ActivityVO alloc]initWithDictionary:[response objectForKey:@"activityVO"] error:nil];
    }];
    _yesterdayTextView.text = yesterdayActivity.detail;
}

@end
