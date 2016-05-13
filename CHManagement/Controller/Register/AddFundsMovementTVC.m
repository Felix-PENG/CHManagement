//
//  AddFundsMovementTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AddFundsMovementTVC.h"
#import "NetworkManager.h"
#import "MBProgressHUD+Extends.h"
#import "ResultVO.h"
#import "Constants.h"

@interface AddFundsMovementTVC () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (strong, nonatomic) UIPickerView *directionPickerView;
@property (weak, nonatomic) IBOutlet UITextField *directionTextField;
@end

@implementation AddFundsMovementTVC

- (UIPickerView *)directionPickerView
{
    if (!_directionPickerView) {
        _directionPickerView = [[UIPickerView alloc] init];
        _directionPickerView.dataSource = self;
        _directionPickerView.delegate = self;
        [_directionPickerView sizeToFit];
    }
    return _directionPickerView;
}

- (void)setDirectionTextField:(UITextField *)directionTextField
{
    _directionTextField = directionTextField;
    self.directionTextField.inputView = self.directionPickerView;
    self.directionTextField.delegate = self;
}

- (void)doneSelect
{
    [self.directionTextField endEditing:YES];
}

- (NSDictionary *)fundsDirections
{
    return @{@(BILL_IN) : @"进账",
              @(BILL_OFF) : @"出账"};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.bill) {
        self.navigationItem.title = @"资金变动更新";
        self.directionTextField.text = [self fundsDirections][@(self.bill.in_off)];
        self.detailTextField.text = self.bill.detail;
        self.moneyTextField.text = [NSString stringWithFormat:@"%.1f", self.bill.money];
    }
}

- (IBAction)doneButtonPressed:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD hudWithMessage:@"请稍等..."];
    if (self.bill) {
        [[NetworkManager sharedInstance] changeBillWithId:self.bill.id
                                              withContent:self.detailTextField.text
                                                withMoney:[self.moneyTextField.text doubleValue]
                                               withIn_off:[self.directionPickerView selectedRowInComponent:0]
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
        [[NetworkManager sharedInstance] createBillWithGroupId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"group_id"] integerValue]
                                                   withContent:self.detailTextField.text
                                                     withMoney:[self.moneyTextField.text doubleValue]
                                                    withIn_off:[self.directionPickerView selectedRowInComponent:0]
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

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self fundsDirections].allKeys.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self fundsDirections][@(row)];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger index = [self.directionPickerView selectedRowInComponent:0];
    self.directionTextField.text = [self fundsDirections][@(index)];
}

@end
