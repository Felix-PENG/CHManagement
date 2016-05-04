//
//  ModifyPasswordVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/29.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ModifyPasswordVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MBProgressHUD+Extends.h"

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
    self.hintLabel.hidden = YES;
    NSInteger user_id = [[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]integerValue];
    
    NSString* oldPwd = self.oldPwdTextField.text;
    NSString* newPwd = self.nPwdTextField.text;
    NSString* repeatNewPwd = self.repeatPwdTextField.text;
    
    if([oldPwd isEqualToString:@""]||[newPwd isEqualToString:@""]||[repeatNewPwd isEqualToString:@""]){
        self.hintLabel.text = @"请将信息填写完整";
        self.hintLabel.hidden = NO;
    }else if(![newPwd isEqualToString:repeatNewPwd]){
        _hintLabel.text = @"两次输入的新密码不一致";
        self.hintLabel.hidden = NO;
    }else{
        [[NetworkManager sharedInstance]changePswd:oldPwd withNewPswd:newPwd withUserId:user_id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            if([resultVO success] == 0){
                NSString* token = [response objectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:[resultVO message] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

@end
