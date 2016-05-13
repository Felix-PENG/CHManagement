//
//  RegisterPurchaseDetailTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterPurchaseDetailTVC.h"
#import "Constants.h"
#import "MBProgressHUD+Extends.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkManager.h"
#import <QiNiuSDK.h>
#import "ResultVO.h"
#import "ErrorHandler.h"
#import "QiNiuVO.h"
#import "File.h"

@interface RegisterPurchaseDetailTVC ()
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchasePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachImageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

@implementation RegisterPurchaseDetailTVC

- (UIImageView *)imageView
{
    return self.attachImageView;
}

- (void)setUploadable:(BOOL)uploadable
{
    _uploadable = uploadable;
    [self checkUploadState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkUploadState];
    
    self.entryLabel.text = self.bill.name;
    self.modelLabel.text = self.bill.type;
    self.amountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.bill.num];
    self.purchasePriceLabel.text = [NSString stringWithFormat:@"%.1f", self.bill.unit_price];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.1f", self.bill.money];
    self.companyLabel.text = self.bill.dealer_name;
    NSLog(@"%@", self.bill.url);
    [self.attachImageView setImageWithURL:[NSURL URLWithString:self.bill.url]];
}

- (void)checkUploadState
{
    if (!self.uploadable) {
        self.addButton.hidden = YES;
        self.navigationItem.rightBarButtonItems = nil;
    }
}

- (IBAction)addButtonPressed:(id)sender
{
    [self pickImage];
}

- (IBAction)finishButtonPressed:(id)sender
{
    if (!self.attachImageView.image) {
        [MBProgressHUD showSuccessWithMessage:@"请上传发票" toView:self.view completion:nil];
        return;
    }
    [self uploadImage:self.attachImageView.image];
}

- (void)dealWithQiNiuKey:(NSString *)key
{
    [[NetworkManager sharedInstance] finishBillMaterialsWithId:self.bill.id withStatus:STATUS_FINISHED withUrl:key completionHandler:^(NSDictionary *response) {
        ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        if (result.success == 0) {
            [self.delegate needRefresh];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ErrorHandler showErrorAlert:@"上传失败"];
        }
    }];
}

@end
