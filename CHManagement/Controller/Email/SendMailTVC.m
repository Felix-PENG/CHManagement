//
//  SendMailTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "SendMailTVC.h"
#import "UserVO.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MBProgressHUD+Extends.h"
#import "MailBoxVC.h"
#import "ChooseUserTVC.h"
#import "ErrorHandler.h"
#import "UserInfo.h"

static NSString * const chooseUserSegue = @"chooseUser";

@interface SendMailTVC ()
@property (weak,nonatomic) IBOutlet UIButton* receiversButton;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation SendMailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.receivers = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated{
    if([self.receivers count] > 0){
        NSString* receiverNames = [NSString string];
        for(UserVO* userVO in self.receivers){
            receiverNames = [receiverNames stringByAppendingFormat:@"%@; ",[userVO name]];
        }
        [self.receiversButton setTitle:receiverNames forState:UIControlStateNormal];
    }
}

#pragma mark IBAction
- (IBAction)cancelButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendButtonPressed:(id)sender {
    NSString* content = self.contentTextView.text;
    
    NSInteger user_id = [UserInfo sharedInstance].id;
    
    if([self.receivers count] == 0||[content isEqualToString:@""]){
        UIAlertController* alert = [ErrorHandler showErrorAlert:@"收件人与内容均不得为空"];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSMutableString* idList = [NSMutableString stringWithString:@"["];
        
        for(UserVO* user in self.receivers){
            [idList appendFormat:@"%@,",[NSNumber numberWithInteger:[user id]]];
        }
        
        [idList deleteCharactersInRange:NSMakeRange([idList length]-1, 1)];
        [idList appendString:@"]"];
        
        [[NetworkManager sharedInstance]createMessageWithIdList:idList withContent:content withUserId:user_id completionHandler:^(NSDictionary *response) {
            ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            
            if([resultVO success] == 0){
                [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                    [self.delegate needRefresh];
                    [self.delegate switchViewToOutBox];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                UIAlertController* alert = [ErrorHandler showErrorAlert:[resultVO message]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:chooseUserSegue]) {
        ChooseUserTVC* chooseUserTVC = segue.destinationViewController;
        chooseUserTVC.choosedUserList = self.receivers;
    }
}


@end
