//
//  RegisterDetailTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterDetailTVC.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD+Extends.h"
#import "NetworkManager.h"
#import <QiNiuSDK.h>
#import "ResultVO.h"
#import "ErrorHandler.h"
#import "QiNiuVO.h"
#import "File.h"

@interface RegisterDetailTVC ()
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UILabel *singlePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachImageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@end

@implementation RegisterDetailTVC

- (void)setUploadable:(BOOL)uploadable
{
    _uploadable = uploadable;
    [self checkUploadState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkUploadState];
    
    self.entryLabel.text = self.bill.name;
    self.singlePriceLabel.text = [NSString stringWithFormat:@"%.1f", self.bill.unit_price];
    self.amountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.bill.num];
    self.remarkLabel.text = self.bill.detail;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.1f", self.bill.money];
    self.statusLabel.text = self.bill.finish_status == STATUS_NOT_FINISHED ? @"进行中" : @"已完成";
    NSLog(@"%@", self.bill.url);
//    [self.attachImageView setImageWithURL:[NSURL URLWithString:self.bill.url] placeholderImage:[UIImage imageNamed:@"loading"]];
    [self.indicator startAnimating];
    [self.attachImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.bill.url]]
                                placeholderImage:nil
                                         success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                    self.attachImageView.image = image;
                                    self.indicator.hidden = YES;
    }
                                         failure:nil];
}

- (UIImageView *)imageView
{
    return self.attachImageView;
}

- (void)checkUploadState
{
    if (!self.uploadable) {
        self.addButton.hidden = YES;
        self.navigationItem.rightBarButtonItems = nil;
    } else {
        self.indicator.hidden = YES;
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
    [[NetworkManager sharedInstance] finishBillOthersWithId:self.bill.id withStatus:STATUS_FINISHED withUrl:key completionHandler:^(NSDictionary *response) {
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
