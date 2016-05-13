//
//  AddBuildingMaterialSellTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AddBuildingMaterialSellTVC.h"
#import "NetworkManager.h"
#import "Constants.h"
#import "MBProgressHUD+Extends.h"
#import "ResultVO.h"

@interface AddBuildingMaterialSellTVC ()
@property (weak, nonatomic) IBOutlet UITextField *entryTextField;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *sellPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;


@end

@implementation AddBuildingMaterialSellTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.bill) {
        self.navigationItem.title = @"建材出售更新";
        self.entryTextField.text = self.bill.name;
        self.modelTextField.text = self.bill.type;
        self.amountTextField.text = [NSString stringWithFormat:@"%ld", (long)self.bill.num];
        self.sellPriceTextField.text = [NSString stringWithFormat:@"%.1f", self.bill.unit_price];
        self.totalPriceTextField.text = [NSString stringWithFormat:@"%.1f", self.bill.money];
        self.companyTextField.text = self.bill.dealer_name;
        self.descriptionTextField.text = self.bill.detail;
    }
}

- (IBAction)doneButtonPressed:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD hudWithMessage:@"请稍等..."];
    if (self.bill) {
        [[NetworkManager sharedInstance] changeBillMaterialsWithId:self.bill.id
                                                       withGroupId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"group_id"] integerValue]
                                                       withContent:self.descriptionTextField.text withMoney:[self.totalPriceTextField.text doubleValue]
                                                          withName:self.entryTextField.text withType:self.modelTextField.text
                                                     withUnitPrice:[self.sellPriceTextField.text doubleValue]
                                                           withNum:[self.amountTextField.text integerValue]
                                                        withIn_off:BILL_OFF
                                                    withDealerName:self.companyTextField.text
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
        [[NetworkManager sharedInstance] createBillMaterialsWithGroupId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"group_id"] integerValue]
                                                            withContent:self.descriptionTextField.text
                                                              withMoney:[self.totalPriceTextField.text doubleValue]
                                                               withName:self.entryTextField.text
                                                               withType:self.modelTextField.text
                                                          withUnitPrice:[self.sellPriceTextField.text doubleValue]
                                                                withNum:[self.amountTextField.text integerValue]
                                                             withIn_off:BILL_OFF
                                                         withDealerName:self.companyTextField.text
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
