//
//  ReportRegisterTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportRegisterTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "ErrorHandler.h"
#import "MBProgressHUD+Extends.h"
#import "Utils.h"

@interface ReportRegisterTVC ()

@property (nonatomic, weak) IBOutlet UITextField* entryField;
@property (nonatomic, weak) IBOutlet UITextField* unit_priceField;
@property (nonatomic, weak) IBOutlet UITextField* numField;
@property (nonatomic, weak) IBOutlet UITextField* remarkField;
@property (nonatomic, weak) IBOutlet UITextField* totalPriceField;

@end


@implementation ReportRegisterTVC{
    BOOL isAddNew;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.auditOthersVO isKindOfClass:[AuditOthersVO class]]){
        self.entryField.text = self.auditOthersVO.name;
        self.unit_priceField.text = [NSString stringWithFormat:@"%.2f",self.auditOthersVO.unit_price];
        self.numField.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.auditOthersVO.num]];
        self.remarkField.text = self.auditOthersVO.detail;
        self.totalPriceField.text = [NSString stringWithFormat:@"%.2f",self.auditOthersVO.money];
        
        isAddNew = NO;
    }else{
        isAddNew = YES;
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

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitButtonPressed:(id)sender{
    [self uploadAuditOthersData];
}

#pragma mark upload data
- (void)uploadAuditOthersData{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[userData objectForKey:@"user_id"]integerValue];
    NSInteger group_id = [[userData objectForKey:@"group_id"]integerValue];
    
    NSString* entry = self.entryField.text;
    NSString* unit_price = self.unit_priceField.text;
    NSString* num = self.numField.text;
    NSString* remark = self.remarkField.text;
    NSString* totalPrice = self.totalPriceField.text;
   
    if([entry isEqualToString:@""]||[unit_price isEqualToString:@""]||[num isEqualToString:@""]||[remark isEqualToString:@""]||[totalPrice isEqualToString:@""]){
        UIAlertController* alertView = [ErrorHandler showErrorAlert:@"选项不得为空"];
        [self presentViewController:alertView animated:YES completion:nil];
    }else if(![Utils isInputPositiveInteger:num]){
        UIAlertController* alertView = [ErrorHandler showErrorAlert:@"数量必须为正整数"];
        [self presentViewController:alertView animated:YES completion:nil];
    }else if(![Utils isInputPositiveDouble:unit_price] || ![Utils isInputPositiveDouble:totalPrice]){
        UIAlertController* alertView = [ErrorHandler showErrorAlert:@"单价和总价必须为正整数或正小数"];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        if(isAddNew){
            [[NetworkManager sharedInstance] createAuditOthersWithGroupId:group_id withContent:remark withMoney:[totalPrice doubleValue] withName:entry withUnitPrice:[unit_price doubleValue] withNum:[num integerValue] withUserId:user_id completionHandler:^(NSDictionary *response) {
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                
                if([resultVO success] == 0){
                    [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                        [self.delegate needRefresh];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }else{
                    UIAlertController* alertView = [ErrorHandler showErrorAlert:[resultVO message]];
                    [self presentViewController:alertView animated:YES completion:nil];
                }
            }];
        }else{
            NSInteger auditOthers_id = self.auditOthersVO.id;
            [[NetworkManager sharedInstance] changeAuditOthersWithId:auditOthers_id withContent:remark withMoney:[totalPrice doubleValue] withName:entry withUnitPrice:[unit_price doubleValue] withNum:[num integerValue] withUserId:user_id completionHandler:^(NSDictionary *response) {
                ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                
                if([resultVO success] == 0){
                    [MBProgressHUD showSuccessWithMessage:[resultVO message] toView:self.view completion:^{
                        [self.delegate needRefresh];
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
