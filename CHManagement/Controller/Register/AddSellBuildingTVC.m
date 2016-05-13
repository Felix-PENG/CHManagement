//
//  AddSellBuildingTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AddSellBuildingTVC.h"
#import "NetworkManager.h"
#import "MBProgressHUD+Extends.h"
#import "ResultVO.h"

@interface AddSellBuildingTVC ()
@property (weak, nonatomic) IBOutlet UITextField *buildingLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *buyerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *buyerPhoneNumberTextField;

@end

@implementation AddSellBuildingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.bill) {
        self.navigationItem.title = @"售楼更新";
        self.buildingLocationTextField.text = self.bill.detail;
        self.priceTextField.text = [NSString stringWithFormat:@"%.1f", self.bill.money];
        self.buyerNameTextField.text = self.bill.purchaser_name;
        self.buyerPhoneNumberTextField.text = self.bill.purchaser_phone;
    }
}
- (IBAction)doneButtonPressed:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD hudWithMessage:@"请稍等..."];
    if (self.bill) {
        [[NetworkManager sharedInstance] changeBillBuildingWithId:self.bill.id
                                                      withContent:self.buildingLocationTextField.text
                                                        withMoney:[self.priceTextField.text doubleValue]
                                                      withPurName:self.buyerNameTextField.text
                                                     withPurPhone:self.buyerPhoneNumberTextField.text
                                                       withUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] integerValue]
                                                completionHandler:^(NSDictionary *response) {
            ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            if (result.success == 0) {
                [self.delegate needRefresh];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [hud hide:YES];
        }];
    } else {
        [[NetworkManager sharedInstance] createBillBuildingWithGroupId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"group_id"] integerValue]
                                                           withContent:self.buildingLocationTextField.text
                                                             withMoney:[self.priceTextField.text doubleValue]
                                                           withPurName:self.buyerNameTextField.text
                                                          withPurPhone:self.buyerPhoneNumberTextField.text
                                                            withUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] integerValue]
                                                     completionHandler:^(NSDictionary *response) {
                                                         ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                                                         if (result.success == 0) {
                                                             [self.delegate needRefresh];
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }
                                                         [hud hide:YES];
                                                     }];
    }
}

@end
