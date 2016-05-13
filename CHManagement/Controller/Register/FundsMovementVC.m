//
//  FundsMovementVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "FundsMovementVC.h"
#import "FundsMovementTVC.h"
#import "AddFundsMovementTVC.h"

@interface FundsMovementVC ()

@end

@implementation FundsMovementVC
{
    FundsMovementTVC *_tvc;
}

- (void)setGroupID:(NSInteger)groupID
{
    _tvc.groupID = groupID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"资金变动列表";
    
    _tvc = [[FundsMovementTVC alloc] init];
    _tvc.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [self.view addSubview:_tvc.view];
    [self addChildViewController:_tvc];
}

- (NSArray *)rightNavigationItems
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    return @[addItem];
}

- (void)addButtonPressed
{
    AddFundsMovementTVC *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddFundsMovementTVC"];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
