//
//  LeftMenuViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/27.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MainViewController.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "SignStatusVO.h"
#import "ErrorHandler.h"
#import "UserInfo.h"
#import "AboutView.h"

@interface LeftMenuViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (nonatomic, strong) AboutView *aboutView;
@end

@implementation LeftMenuViewController{
    NSInteger _user_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification) name:@"SignIn" object:nil];
}

- (void)handleNotification
{
    NSLog(@"Left menu got notification");
    [self loadData];
}

- (void)loadData
{
    NSString* user_name = [UserInfo sharedInstance].userName;
    NSNumber* credit = @([UserInfo sharedInstance].credit);
    NSInteger user_id = [UserInfo sharedInstance].id;
    _user_id = user_id;
    
    self.userNameLabel.text = user_name;
    self.creditLabel.text = [NSString stringWithFormat:@"%@",credit];
    
    [[NetworkManager sharedInstance]getSignStatusByUserId:_user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if(resultVO.success == 0){
            SignStatusVO* signStatusVO = [[SignStatusVO alloc]initWithDictionary:[response objectForKey:@"signStatusVO"] error:nil];
            
            if(signStatusVO.status == 0){
                [self.signInButton setTitle:@"未签到" forState:UIControlStateNormal];
                [self.signInButton setEnabled:YES];
            }else{
                [self.signInButton setTitle:@"已签到" forState:UIControlStateNormal];
                [self.signInButton setEnabled:NO];
            }
            
        }else{
            UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)signInButtonPressed:(id)sender
{
    [[NetworkManager sharedInstance]signByUserId:_user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if(resultVO.success == 0){
            [self.signInButton setTitle:@"已签到" forState:UIControlStateNormal];
            [self.signInButton setEnabled:NO];
        }else{
            UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (IBAction)HomeButtonPressed:(id)sender
{
    UIViewController *rootViewController = self.parentViewController;
    if ([rootViewController isKindOfClass:[MainViewController class]]) {
        [((MainViewController *)rootViewController) hideMenuViewController];
    }
}

- (IBAction)modifyPasswordButtonPressed:(id)sender
{
    
}

- (IBAction)logOffButtonPressed:(id)sender
{
    [[NetworkManager sharedInstance] deleteDeviceToken:[UserInfo sharedInstance].id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        if(resultVO.success == 0){
            [self HomeButtonPressed:nil];
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SignInVC"] animated:YES completion:nil];
            
            [UserInfo remove];
        }
    }];
}

- (AboutView *)aboutView
{
    if (!_aboutView) {
        _aboutView = [[[NSBundle mainBundle] loadNibNamed:@"AboutView" owner:nil options:nil] firstObject];
        _aboutView.frame = [UIScreen mainScreen].applicationFrame;
    }
    return _aboutView;
}

- (IBAction)aboutButtonPressed:(id)sender
{
    [self.aboutView showToView:[UIApplication sharedApplication].keyWindow];
}

@end
