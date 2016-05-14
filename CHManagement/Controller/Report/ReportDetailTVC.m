//
//  ReportDetailTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportDetailTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "ErrorHandler.h"
#import "MBProgressHUD+Extends.h"
#import "Utils.h"

#define APPROVE_STATUS 3
#define REJECT_STATUS 2

@interface ReportDetailTVC ()
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UILabel *singlePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation ReportDetailTVC

- (void)setCheckable:(BOOL)checkable
{
    if (!checkable) {
        self.navigationItem.rightBarButtonItems = nil;
    }
    _checkable = checkable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.auditOthersVO isKindOfClass:[AuditOthersVO class]]){
        self.entryLabel.text = self.auditOthersVO.name;
        self.singlePriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.auditOthersVO.unit_price];
        self.amountLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.auditOthersVO.num]];
        self.remarkLabel.text = self.auditOthersVO.detail;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.auditOthersVO.money];
        
        NSInteger status = self.auditOthersVO.audit_status;
        
        if(status == 0){
            self.statusLabel.text = @"待审核";
        }else if(status == 1){
            self.statusLabel.text = @"已审核";
        }else if(status == 2){
            self.statusLabel.text = @"被驳回";
        }else{
            self.statusLabel.text = @"审核通过";
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
            [[NetworkManager sharedInstance]auditAuditOthersWithId:self.auditOthersVO.id withStatus:REJECT_STATUS withReason:reasonField.text completionHandler:^(NSDictionary *response) {
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

- (IBAction)approveButtonPressed:(id)sender {
    [[NetworkManager sharedInstance]auditAuditOthersWithId:self.auditOthersVO.id withStatus:APPROVE_STATUS withReason:@"pass" completionHandler:^(NSDictionary *response) {
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

@end
