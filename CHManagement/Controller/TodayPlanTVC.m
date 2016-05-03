//
//  TodayPlanTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/2.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "TodayPlanTVC.h"

@interface TodayPlanTVC ()
@property (weak, nonatomic) IBOutlet UITextView *planTextView;
@property (weak, nonatomic) IBOutlet UITextView *arrangementTextView;

@end

@implementation TodayPlanTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *)arrangement
{
    return self.arrangementTextView.text;
}

- (NSString *)plan
{
    return self.planTextView.text;
}

@end
