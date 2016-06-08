//
//  SignUpViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/6/7.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "SignUpViewController.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "ErrorHandler.h"
#import "MBProgressHUD+Extends.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainField;
@property (weak, nonatomic) IBOutlet UITextField *companyCodeField;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (IBAction)registerButtonPressed:(id)sender {
    self.hintLabel.hidden = YES;
    
    NSString* account = self.accountField.text;
    NSString* userName = self.userNameField.text;
    NSString* pwd = self.pwdField.text;
    NSString* pwdAgain = self.pwdAgainField.text;
    NSString* code = self.companyCodeField.text;
    
    if([account isEqualToString:@""]||[userName isEqualToString:@""]||[pwd isEqualToString:@""]||[pwdAgain isEqualToString:@""]||[code isEqualToString:@""]){
        self.hintLabel.text = @"各项不得为空";
        self.hintLabel.hidden = NO;
    }else if(![pwd isEqualToString:pwdAgain]){
        self.hintLabel.text = @"两次密码不一致";
        self.hintLabel.hidden = NO;
    }else{
        [[NetworkManager sharedInstance] signUpWithEmail:account withPswd:pwd withName:userName withCompanyCode:code completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            if([resultVO success] == 0){
                [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                [self presentViewController:alert animated:YES completion:nil];
            }

        }];
    }
}

@end
