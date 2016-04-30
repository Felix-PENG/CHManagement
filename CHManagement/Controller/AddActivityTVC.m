//
//  AddActivityTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/30.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AddActivityTVC.h"

@interface AddActivityTVC ()

@end

@implementation AddActivityTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[self.view tintColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveButtonPressed:(id)sender
{
    
}

@end
