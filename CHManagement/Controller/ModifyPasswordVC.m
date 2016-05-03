//
//  ModifyPasswordVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/29.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ModifyPasswordVC.h"

@interface ModifyPasswordVC()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation ModifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setBarTintColor:[self.view tintColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)modifyButtonPressed:(id)sender
{
    
}

@end
