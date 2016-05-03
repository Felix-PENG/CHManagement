//
//  PlanTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "PlanTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "ScheduleVO.h"
#import "ActivityCell.h"
#import "LoadMoreCell.h"
#import "AddPlanVC.h"

static NSString * const CellIdentifier = @"ActivityCell";
static NSString * const LoadMoreCellIdentifier = @"LoadMoreCell";
static NSString * const AddPlanSegue = @"AddPlan";

@interface PlanTVC (){
    NSUInteger _page;
    NSMutableArray *_planList;
    BOOL _repeatLoad;
    BOOL _noMoreData;
}

@end

@implementation PlanTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    nib = [UINib nibWithNibName:LoadMoreCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:LoadMoreCellIdentifier];
    
    // cell自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 98.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!_repeatLoad) {
        [self.refreshControl beginRefreshing];
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        _repeatLoad = YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _planList.count > 0? _planList.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _planList.count) {
        ActivityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        ScheduleVO *plan = [_planList objectAtIndex:indexPath.row];
        
        [cell configureWithContent:plan.today time:plan.time];
        
        return cell;
    } else {
        LoadMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
        cell.status = _noMoreData ? NoMore : ClickToLoad;
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _planList.count) {
        [self performSegueWithIdentifier:AddPlanSegue sender:[_planList objectAtIndex:indexPath.row]];
    } else {
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadPlanListWithPage:++_page];
    }
}

#pragma mark IBAction
- (IBAction)refresh
{
    _page = 1;
    [self loadPlanListWithPage:_page];
}

#pragma  mark load data
- (void)loadPlanListWithPage:(NSInteger)page{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[userData objectForKey:@"user_id"]integerValue];
    [[NetworkManager sharedInstance]getSchedulesWithPage:page withUserId:user_id completionHandler:^(NSDictionary *response) {
        if(page <= 1){
            [_planList removeAllObjects];
        }
        
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        if([resultVO success] == 0){
            NSLog(@"%@",[resultVO message]);
            NSArray* planList = [response objectForKey:@"scheduleVOList"];
            if(planList.count > 0){
                for(NSDictionary* planDict in planList){
                    [_planList addObject:[[ScheduleVO alloc]initWithDictionary:planDict error:nil]];
                }
                _noMoreData = NO;
            } else {
                _noMoreData = YES;
            }
            
            [self.tableView reloadData];
            
            if (self.refreshControl.isRefreshing) {
                [self.refreshControl endRefreshing];
            }
        }else{
            NSLog(@"%@",[resultVO message]);
        }
    }];
}

@end
