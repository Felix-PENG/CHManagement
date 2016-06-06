//
//  RegisterViewController.m
//  CHManagement
//
//  Created by harveyprince on 16/6/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameField;

@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainField;
@property (weak, nonatomic) IBOutlet UITextField *companyCodeField;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)registerButtonPressed:(id)sender {
    NSString* userName = self.userNameField.text;
    NSString* pwd = self.pwdField.text;
    NSString* pwdAgain = self.pwdAgainField.text;
    NSString* code = self.companyCodeField.text;
    
    if([userName isEqualToString:@""]||[pwd isEqualToString:@""]||[pwdAgain isEqualToString:@""]||[code isEqualToString:@""]){
        self.hintLabel.text = @"各项不得为空";
        self.hintLabel.hidden = NO;
    }else if(![pwd isEqualToString:pwdAgain]){
        self.hintLabel.text = @"两次密码不一致";
        self.hintLabel.hidden = NO;
    }else{
        
    }
}


@end
