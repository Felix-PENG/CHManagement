//
//  ContentViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/27.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ContentViewController.h"
#import "MainViewController.h"

#define SECTION_HEADER_HEIGHT 28.0
#define TOP_MENU_CELL_HEIGHT 84.0
#define CELL_HEIGHT 44.0

@interface ContentViewController ()
//@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [self.tableView dequeueReusableCellWithIdentifier:@"TopMenuCell"];
    } else {
        return [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, SECTION_HEADER_HEIGHT)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 50, headerView.frame.size.height)];
        label.text = [NSString stringWithFormat:@"%ld", (long)section];
        [headerView addSubview:label];
        [headerView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.07]];
        return headerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return TOP_MENU_CELL_HEIGHT;
    } else {
        return CELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return SECTION_HEADER_HEIGHT;
    }
}


- (IBAction)refresh
{
    NSLog(@"refresh");
    
    [self.refreshControl endRefreshing];
}

#pragma mark - Jump

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)menuButtonPressed:(id)sender
{
    UIViewController *rootViewController = self.parentViewController.parentViewController;
    if ([rootViewController isKindOfClass:[MainViewController class]]) {
        [((MainViewController *)rootViewController) presentLeftMenuViewController];
    }
}

@end
