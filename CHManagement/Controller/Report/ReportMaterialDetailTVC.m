//
//  ReportMaterialDetailTVC.m
//  CHManagement
//
//  Created by Peng, Troy on 5/9/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "ReportMaterialDetailTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MBProgressHUD+Extends.h"
#import "ErrorHandler.h"

#define APPROVE_STATUS 3
#define REJECT_STATUS 2

@interface ReportMaterialDetailTVC()

@property (nonatomic, weak) IBOutlet UILabel* entryLabel;
@property (nonatomic, weak) IBOutlet UILabel* typeLabel;
@property (nonatomic, weak) IBOutlet UILabel* numLabel;
@property (nonatomic, weak) IBOutlet UILabel* unitPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* totalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* dealerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* statusLabel;
@end

@implementation ReportMaterialDetailTVC

- (void)setCheckable:(BOOL)checkable
{
    if (!checkable) {
        self.navigationItem.rightBarButtonItems = nil;
    }
    _checkable = checkable;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([self.auditMaterialsVO isKindOfClass:[AuditMaterialsVO class]]){
        self.entryLabel.text = self.auditMaterialsVO.name;
        self.typeLabel.text = self.auditMaterialsVO.type;
        self.numLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.auditMaterialsVO.num]];
        self.unitPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.auditMaterialsVO.unit_price];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.auditMaterialsVO.money];
        self.dealerNameLabel.text = self.auditMaterialsVO.dealer_name;
        
        NSInteger status = self.auditMaterialsVO.audit_status;
        
        if(status == 0){
            self.statusLabel.text = @"未处理";
        }else if(status == 1){
            self.statusLabel.text = @"已审核";
        }else if(status == 2){
            self.statusLabel.text = @"被驳回";
        }else{
            self.statusLabel.text = @"审核通过";
        }
    }
}
- (IBAction)approveButtonPressed:(id)sender {
    [[NetworkManager sharedInstance]auditAuditMaterialsWithId:self.auditMaterialsVO.id withStatus:APPROVE_STATUS withReason:@"pass" completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if(resultVO.success == 0){
            [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                [self.delegate needRefresh];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            UIAlertController* alertView = [ErrorHandler showErrorAlert:[resultVO message]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }];
}

- (IBAction)rejectButtonPressed:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"输入驳回理由" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"驳回理由";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UITextField *reasonField = alert.textFields.firstObject;
        
        if([reasonField.text isEqualToString:@""]){
            UIAlertController* alertView = [ErrorHandler showErrorAlert:@"理由不得为空"];
            [self presentViewController:alertView animated:YES completion:nil];
        }else{
            [[NetworkManager sharedInstance]auditAuditMaterialsWithId:self.auditMaterialsVO.id withStatus:REJECT_STATUS withReason:reasonField.text completionHandler:^(NSDictionary *response) {
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                
                if(resultVO.success == 0){
                    [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                        [self.delegate needRefresh];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }else{
                    UIAlertController* alertView = [ErrorHandler showErrorAlert:[resultVO message]];
                    [self presentViewController:alertView animated:YES completion:nil];
                }
            }];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
