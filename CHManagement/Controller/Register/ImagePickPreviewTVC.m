//
//  ImagePickPreviewTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/12.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ImagePickPreviewTVC.h"
#import "File.h"
#import "MBProgressHUD+Extends.h"
#import "NetworkManager.h"
#import <QiniuSDK.h>
#import "ResultVO.h"
#import "Constants.h"
#import "QiNiuVO.h"
#import "ErrorHandler.h"

@interface ImagePickPreviewTVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation ImagePickPreviewTVC

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    [self.imageView addGestureRecognizer:tapRecognizer];
}

- (void)imageViewTapped
{
    if (self.imageView.image) {
        NSData *imgData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        NSString *tmpPath = [NSString stringWithFormat:@"%@/tmp.jpg", NSTemporaryDirectory()];
        [imgData writeToFile:tmpPath atomically:YES];
        UIDocumentInteractionController *dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:tmpPath]];
        dic.delegate = self;
        [dic presentPreviewAnimated:YES];
    }
}

- (void)pickImage
{
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)image
{
    NSString *uniqueName = [File dataTimeImageName];
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
                          // may upload to server
                          [self dealWithQiNiuKey:key];
                      } option:opt];
        } else {
            [ErrorHandler showErrorAlert:@"上传失败"];
        }
    }];

}

- (void)dealWithQiNiuKey:(NSString *)key
{
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
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
