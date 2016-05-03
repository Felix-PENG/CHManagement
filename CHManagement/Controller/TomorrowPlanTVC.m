//
//  TomorrowPlanTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/2.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "TomorrowPlanTVC.h"

@interface TomorrowPlanTVC ()
@property (weak, nonatomic) IBOutlet UITextView *planTextView;

@end

@implementation TomorrowPlanTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *)plan
{
    return self.planTextView.text;
}

@end
