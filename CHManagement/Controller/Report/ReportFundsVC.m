//
//  ReportFundsVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportFundsVC.h"
#import "TabbedScrollViewController.h"
#import "ReportFundsGoingTVC.h"
#import "ReportFundsRejectedTVC.h"
#import "TabItem.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MyGroup.h"
#import "UserInfo.h"
#import "ReportRegisterTVC.h"

@interface ReportFundsVC ()

@end

@implementation ReportFundsVC{
    UIAlertController* _sheetAlert;
    ReportFundsGoingTVC * _rfgtvc;
    ReportFundsRejectedTVC * _rfrtvc;
    NSInteger admin_group_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // title
    self.navigationItem.title = @"经费审核情况";
    
    // contents
    _rfgtvc = [[ReportFundsGoingTVC alloc] init];
    _rfrtvc = [[ReportFundsRejectedTVC alloc] init];
    
    TabItem *item1 = [[TabItem alloc] initWithTab:@"进行中" controller:_rfgtvc];
    TabItem *item2 = [[TabItem alloc] initWithTab:@"被驳回" controller:_rfrtvc];
    
    TabbedScrollViewController *tsvc = [[TabbedScrollViewController alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) items:@[item1, item2]];
    
    [self.view addSubview:tsvc.view];
    [self addChildViewController:tsvc];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // bar button items
    UIBarButtonItem *roleItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_assignment_ind_white_24dp"] style:UIBarButtonItemStylePlain target:self action:@selector(roleButtonPressed)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    
    NSInteger group_id = [UserInfo sharedInstance].groupId;
    
    [[NetworkManager sharedInstance] getAdminGroupIdWithCompletionHandler:^(NSDictionary *response) {
        admin_group_id = [[response objectForKey:@"id"]integerValue];
    }];
    
    if(group_id == admin_group_id){
        self.navigationItem.rightBarButtonItems = @[addItem, roleItem];
        
        _sheetAlert = [UIAlertController alertControllerWithTitle:@"选择部门" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [[NetworkManager sharedInstance]getAllGroupsWithCompletionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];;
            
            if([resultVO success] == 0){
                NSArray* groupList = [response objectForKey:@"groupList"];
                for(NSDictionary* groupDict in groupList){
                    MyGroup* group = [[MyGroup alloc]initWithDictionary:groupDict error:nil];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:group.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [_rfgtvc setChoosedGroupId:[NSNumber numberWithInteger:group.id]];
                        [_rfgtvc refresh];
                        [_rfrtvc setChoosedGroupId:[NSNumber numberWithInteger:group.id]];
                        [_rfrtvc refresh];
                    }];
                    [_sheetAlert addAction:action];
                }
            }
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];

        [_sheetAlert addAction:cancelAction];
    }else{
        self.navigationItem.rightBarButtonItem = addItem;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)roleButtonPressed
{
    [self presentViewController:_sheetAlert animated:YES completion:nil];
}

- (void)addButtonPressed
{
    UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportRegisterTVC"];
    ReportRegisterTVC* reportRegisterTVC = (ReportRegisterTVC*)controller.topViewController;
    reportRegisterTVC.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark implement protocol methods
- (void)needRefresh{
    _rfrtvc.repeatLoad = NO;
    _rfgtvc.repeatLoad = NO;
}

@end
