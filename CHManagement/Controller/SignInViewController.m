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

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonPressed:(id)sender
{
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [[NetworkManager sharedInstance] signIn:username pswd:password completionHandler:^(NSDictionary * response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        SignInResultVO* signResultVO = [[SignInResultVO alloc]initWithDictionary:[response objectForKey:@"signInResultVO"] error:nil];
        NSLog(@"%@___%@",[resultVO message],[signResultVO token]);
        if (resultVO.success == 0) {
            [self performSegueWithIdentifier:@"SignIn" sender:nil];
        } else {
            
        }
    }];
    
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
