//
//  ReportMaterialVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportMaterialVC.h"
#import "TabbedScrollViewController.h"
#import "ReportMaterialGoingTVC.h"
#import "ReportMaterialRejectedTVC.h"
#import "TabItem.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MyGroup.h"
#import "UserInfo.h"
#import "ReportMaterialRegisterTVC.h"

@interface ReportMaterialVC ()

@end

@implementation ReportMaterialVC{
    UIAlertController* _sheetAlert;
    ReportMaterialGoingTVC * _rmgtvc;
    ReportMaterialRejectedTVC * _rmrtvc;
    NSInteger admin_group_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"建材买入审核情况";
    
    // contents
    _rmgtvc = [[ReportMaterialGoingTVC alloc] init];
    _rmrtvc = [[ReportMaterialRejectedTVC alloc] init];
    
    TabItem *item1 = [[TabItem alloc] initWithTab:@"进行中" controller:_rmgtvc];
    TabItem *item2 = [[TabItem alloc] initWithTab:@"被驳回" controller:_rmrtvc];
    
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
                        [_rmgtvc setChoosedGroupId:[NSNumber numberWithInteger:group.id]];
                        [_rmgtvc refresh];
                        [_rmrtvc setChoosedGroupId:[NSNumber numberWithInteger:group.id]];
                        [_rmrtvc refresh];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)roleButtonPressed
{
    [self presentViewController:_sheetAlert animated:YES completion:nil];
}

- (void)addButtonPressed
{
    UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReportMaterialRegisterTVC"];
    ReportMaterialRegisterTVC* reportMaterialRegisterTVC = (ReportMaterialRegisterTVC*)controller.topViewController;
    reportMaterialRegisterTVC.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark implement protocol methods
- (void)needRefresh{
    _rmgtvc.repeatLoad = NO;
    _rmrtvc.repeatLoad = NO;
}

@end
