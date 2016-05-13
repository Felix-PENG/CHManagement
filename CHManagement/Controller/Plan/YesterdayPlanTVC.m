//
//  YesterdayPlanTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/2.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "YesterdayPlanTVC.h"

@interface YesterdayPlanTVC ()
@property (weak, nonatomic) IBOutlet UITextView *arrangementTextView;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@end

@implementation YesterdayPlanTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.arrangementTextView setEditable:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *)arrangement
{
    return self.arrangementTextView.text;
}

- (void)setArrangement:(NSString *)arrangement{
    self.arrangementTextView.text = arrangement;
}

- (NSString *)summary
{
    return self.summaryTextView.text;
}

- (void)setSummary:(NSString *)summary{
    self.summaryTextView.text = summary;
}

- (void)setSummaryTextViewEditable:(BOOL)editable{
    self.summaryTextView.editable = editable;
}

@end
