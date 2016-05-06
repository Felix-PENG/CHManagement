//
//  BuildingMaterialSellVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "BuildingMaterialSellVC.h"
#import "BuildingMaterialSellTVC.h"
#import "AddBuildingMaterialSellTVC.h"

@interface BuildingMaterialSellVC ()

@end

@implementation BuildingMaterialSellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"建材卖出列表";
    
    BuildingMaterialSellTVC *tvc = [[BuildingMaterialSellTVC alloc] init];
    tvc.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [self.view addSubview:tvc.view];
    [self addChildViewController:tvc];
}

- (NSArray *)rightNavigationItems
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
    return @[addItem];
}

- (void)addButtonPressed
{
    AddBuildingMaterialSellTVC *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddBuildingMaterialSellTVC"];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
