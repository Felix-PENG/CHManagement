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

@interface RegisterDetailTVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UILabel *singlePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachImageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation RegisterDetailTVC
{
    NSURL *_imageURL;
}

- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
    }
    return _imagePickerController;
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
    self.singlePriceLabel.text = [NSString stringWithFormat:@"%.1f", self.bill.unit_price];
    self.amountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.bill.num];
    self.remarkLabel.text = self.bill.detail;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%.1f", self.bill.money];
    self.statusLabel.text = self.bill.finish_status == STATUS_NOT_FINISHED ? @"进行中" : @"已完成";
    NSLog(@"%@", self.bill.url);
    [self.attachImageView setImageWithURL:[NSURL URLWithString:self.bill.url]];
    self.attachImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    [self.attachImageView addGestureRecognizer:tapRecognizer];
}

- (void)imageViewTapped
{
    if (self.attachImageView.image) {
        NSData *imgData = UIImageJPEGRepresentation(self.attachImageView.image, 1.0);
        NSString *tmpPath = [NSString stringWithFormat:@"%@/tmp.jpg", NSTemporaryDirectory()];
        [imgData writeToFile:tmpPath atomically:YES];
        UIDocumentInteractionController *dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:tmpPath]];
        dic.delegate = self;
        [dic presentPreviewAnimated:YES];
    }
}

- (void)checkUploadState
{
    if (!self.uploadable) {
        self.addButton.hidden = YES;
        self.uploadButton.hidden = YES;
        self.navigationItem.rightBarButtonItems = nil;
    }
}

- (IBAction)addButtonPressed:(id)sender
{
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)finishButtonPressed:(id)sender
{
    if (!self.attachImageView.image) {
        [MBProgressHUD showSuccessWithMessage:@"请上传发票" toView:self.view completion:nil];
        return;
    }
    [self uploadImage:self.attachImageView.image];
}

- (NSString *)uniqueImageName
{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *timeStr = [formatter stringFromDate:currDate];
    
    return [NSString stringWithFormat:@"IMG_%@.JPG", timeStr];
}

- (void)uploadImage:(UIImage *)image
{
    NSString *uniqueName = [self uniqueImageName];
    MBProgressHUD *hud = [MBProgressHUD progressHudWithMessage:@"上传中..." toView:self.view.window];
    [[NetworkManager sharedInstance] getUploadTokenWithName:uniqueName withKeyPre:KEY_PRE_PICTURE completionHandler:^(NSDictionary *response) {
        ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        if (result.success == 0) {
            QiNiuVO *qiniu = [[QiNiuVO alloc] initWithDictionary:[response objectForKey:@"qiNiuVO"] error:nil];
            // upload to qiniu
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                hud.progress = percent;
            }params:nil checkCrc:YES cancellationSignal:nil];
            [upManager putData:data
                           key:qiniu.key
                         token:qiniu.token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          NSLog(@"%@", key);
                          NSLog(@"%@", info);
                          NSLog(@"%@", resp);
                          // upload to server
                          [[NetworkManager sharedInstance] finishBillOthersWithId:self.bill.id withStatus:STATUS_FINISHED withUrl:key completionHandler:^(NSDictionary *response) {
                              ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                              if (result.success == 0) {
                                  [self.navigationController popViewControllerAnimated:YES];
                              } else {
                                  [ErrorHandler showErrorAlert:@"上传失败"];
                              }
                          }];
                      } option:opt];
        } else {
            [ErrorHandler showErrorAlert:@"上传失败"];
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.attachImageView.image = image;
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    [navigationController.navigationBar setBarTintColor:[self.view tintColor]];
    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

@end
