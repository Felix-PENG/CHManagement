//
//  SignInViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/27.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "SignInViewController.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "SignInResultVO.h"
#import "MBProgressHUD+Extends.h"
#import "UserInfo.h"
#import "RegisterViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController.navigationBar setBarTintColor:[self.view tintColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self.userNameTextField becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.passwordTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonPressed:(id)sender
{
    self.hintLabel.hidden = YES;
    
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        self.hintLabel.text = @"请将信息填写完整";
        self.hintLabel.hidden = NO;
    } else {
        MBProgressHUD *hud = [MBProgressHUD hudWithMessage:@"登录中..." toView:self.view];
        [UserInfo signIn:username password:password success:^{
            [hud hide:YES];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SignIn" object:nil]];
            [self dismissViewControllerAnimated:YES completion:nil];
        } error:^(NSString *message) {
            [hud hide:YES];
            self.hintLabel.text = message;
            self.hintLabel.hidden = NO;
        }];
    }
}


- (IBAction)registerButtonPressed:(id)sender {
    RegisterViewController *rgstView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:rgstView animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
