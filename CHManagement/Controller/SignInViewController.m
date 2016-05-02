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
        
        [[NetworkManager sharedInstance] signIn:username pswd:password completionHandler:^(NSDictionary * response) {
            [hud hide:YES];
            
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            SignInResultVO* signResultVO = [[SignInResultVO alloc]initWithDictionary:[response objectForKey:@"signInResultVO"] error:nil];
            NSLog(@"%@___%@",[resultVO message],[signResultVO token]);
            
            if (resultVO.success == 0) {
                [self performSegueWithIdentifier:@"SignIn" sender:nil];
                NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
                NSInteger user_id = [[signResultVO user]id];
                NSInteger token_user_id = user_id;
                NSString* token = [signResultVO token];
                NSInteger group_id = [[[signResultVO user]group]id];
                [userData setObject:[NSNumber numberWithInteger:user_id] forKey:@"user_id"];
                [userData setObject:[NSNumber numberWithInteger:token_user_id] forKey:@"token_user_id"];
                [userData setObject:token forKey:@"token"];
                [userData setObject:[NSNumber numberWithInteger:group_id] forKey:@"group_id"];
            } else {
                
                self.hintLabel.text = @"用户名或密码错误";
                self.hintLabel.hidden = NO;
            }
        }];
    
    }
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
