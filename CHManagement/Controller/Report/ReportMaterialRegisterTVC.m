//
//  ReportMaterialRegisterTVC.m
//  CHManagement
//
//  Created by Peng, Troy on 5/10/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "ReportMaterialRegisterTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "ErrorHandler.h"
#import "MBProgressHUD+Extends.h"
#import "Utils.h"
#import "UserInfo.h"

#define IN_OFF 0

@interface ReportMaterialRegisterTVC()
@property (nonatomic, weak) IBOutlet UITextField* entryField;
@property (nonatomic, weak) IBOutlet UITextField* typeField;
@property (nonatomic, weak) IBOutlet UITextField* numField;
@property (nonatomic, weak) IBOutlet UITextField* unitPriceField;
@property (nonatomic, weak) IBOutlet UITextField* totalPriceField;
@property (nonatomic, weak) IBOutlet UITextField* dealerNameField;
@property (nonatomic, weak) IBOutlet UITextField* detailField;


@end

@implementation ReportMaterialRegisterTVC

#pragma mark life cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    if(self.auditMaterialsVO){
        self.entryField.text = self.auditMaterialsVO.name;
        self.typeField.text = self.auditMaterialsVO.type;
        self.numField.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.auditMaterialsVO.num]];
        self.unitPriceField.text = [NSString stringWithFormat:@"%.2f",self.auditMaterialsVO.unit_price];
        self.totalPriceField.text = [NSString stringWithFormat:@"%.2f",self.auditMaterialsVO.money];
        self.dealerNameField.text = self.auditMaterialsVO.dealer_name;
        self.detailField.text = self.auditMaterialsVO.detail;
    }
    
}

#pragma mark IBAction
- (IBAction)cancelButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender{
    NSString* entry = self.entryField.text;
    NSString* type = self.typeField.text;
    NSString* num = self.numField.text;
    NSString* unitPrice = self.unitPriceField.text;
    NSString* totalPrice = self.totalPriceField.text;
    NSString* dealerName = self.dealerNameField.text;
    NSString* detail = self.detailField.text;
    
    if([entry isEqualToString:@""]||[type isEqualToString:@""]||[num isEqualToString:@""]||[unitPrice isEqualToString:@""]||[totalPrice isEqualToString:@""]||[dealerName isEqualToString:@""]||[detail isEqualToString:@""]){
        UIAlertController* alertView = [ErrorHandler showErrorAlert:@"选项不得为空"];
        [self presentViewController:alertView animated:YES completion:nil];
    }else if(![Utils isInputPositiveInteger:num]){
        UIAlertController* alertView = [ErrorHandler showErrorAlert:@"数量必须为正整数"];
        [self presentViewController:alertView animated:YES completion:nil];
    }else if(![Utils isInputPositiveDouble:unitPrice] || ![Utils isInputPositiveDouble:totalPrice]){
        UIAlertController* alertView = [ErrorHandler showErrorAlert:@"单价和总价必须为正整数或正小数"];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        NSInteger user_id = [UserInfo sharedInstance].id;
        NSInteger group_id = [UserInfo sharedInstance].groupId;
        
        if(self.auditMaterialsVO){
            [[NetworkManager sharedInstance]changeAuditMaterialsWithId:self.auditMaterialsVO.id withContent:detail withMoney:[totalPrice doubleValue] withName:entry withType:type withUnitPrice:[unitPrice doubleValue] withNum:[num integerValue] withIn_off:IN_OFF withDealerName:dealerName withUserId:user_id completionHandler:^(NSDictionary *response) {
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                
                if([resultVO success] == 0){
                    [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }else{
                    UIAlertController* alertView = [ErrorHandler showErrorAlert:[resultVO message]];
                    [self presentViewController:alertView animated:YES completion:nil];
                }
            }];
        }else{
            [[NetworkManager sharedInstance] createAuditMaterialsWithGroupId:group_id withContent:detail withMoney:[totalPrice doubleValue] withName:entry withType:type withUnitPrice:[unitPrice doubleValue] withNum:[num integerValue] withIn_off:IN_OFF withDealerName:dealerName withUserId:user_id completionHandler:^(NSDictionary *response) {
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                
                if([resultVO success] == 0){
                    [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }else{
                    UIAlertController* alertView = [ErrorHandler showErrorAlert:[resultVO message]];
                    [self presentViewController:alertView animated:YES completion:nil];
                }
            }];
        }
    }

    
}

@end
