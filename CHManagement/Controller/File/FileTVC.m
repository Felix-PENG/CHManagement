//
//  FileTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "FileTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "FileVO.h"
#import "FileCell.h"
#import "LoadMoreCell.h"
#import "MBProgressHUD+Extends.h"
#import "File.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Constants.h"
#import "QiNiuVO.h"
#import <QiniuSDK.h>
#import "ErrorHandler.h"
#import "UserInfo.h"

static NSString * const CellIdentifier = @"FileCell";
static NSString * const LoadMoreCellIdentifier = @"LoadMoreCell";

@interface FileTVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation FileTVC
{
    NSUInteger _page;
    NSMutableArray *_fileList;
    BOOL _noMoreData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    nib = [UINib nibWithNibName:LoadMoreCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:LoadMoreCellIdentifier];
    
    // cell自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 68.0;
    
    _fileList = [NSMutableArray array];
}

- (void)refresh
{
    _page = 1;
    [_fileList removeAllObjects];
    [self loadDataWithPage:_page];
}

- (void)loadDataWithPage:(NSUInteger)page
{
    [[NetworkManager sharedInstance] getFilesWithPage:page completionHandler:^(NSDictionary *response) {
        ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        if (result.success == 0) {
            NSArray *list = [response objectForKey:@"fileVOList"];
            
            if (list.count > 0) {
                for (NSDictionary *dict in list) {
                    FileVO *fileVO = [[FileVO alloc] initWithDictionary:dict error:nil];
                    File *file = [[File alloc] initWithFileVO:fileVO];
                    [_fileList addObject:file];
                }
                _noMoreData = NO;
            } else {
                _noMoreData = YES;
            }
            [self.tableView reloadData];
        } else {
            [ErrorHandler showErrorAlert:@"加载失败"];
        }
        if (self.refreshControl.isRefreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}


- (void)uploadImage:(UIImage *)image name:(NSString *)name size:(NSString *)size
{
    NSString *uniqueName = [self uniqueNameForImage:name];
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
                          [[NetworkManager sharedInstance] createFileWithName:uniqueName withSize:size withUrl:key withUserId:[UserInfo sharedInstance].id completionHandler:^(NSDictionary *response) {
                              ResultVO *result2 = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
                              if (result2.success == 0) {
                                  [self refresh];
                                  [MBProgressHUD showSuccessWithMessage:@"上传成功" toView:self.view completion:nil];
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

- (void)downloadFile:(File *)file
{
    MBProgressHUD *hud = [MBProgressHUD progressHudWithMessage:@"正在下载..." toView:self.view.window];
    [[NetworkManager sharedInstance] downloadFile:file success:^(id response) {
        [MBProgressHUD showSuccessWithMessage:@"下载完成" toView:self.view completion:nil];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [ErrorHandler showErrorAlert:@"下载失败"];
        [hud hide:YES];
    } progress:^(float progress) {
        hud.progress = progress;
    }];
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

- (NSString *)uniqueNameForImage:(NSString *)imageName
{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeStr = [formatter stringFromDate:currDate];
    
    NSRange splitRange = [imageName rangeOfString:@"."];
    return [NSString stringWithFormat:@"%@_%@.%@", [imageName substringToIndex:splitRange.location], timeStr, [imageName substringFromIndex:splitRange.location + 1]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fileList.count > 0 ? _fileList.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _fileList.count) {
        FileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        File *file = _fileList[indexPath.row];
        [cell setSize:file.fileVO.size dateTime:file.fileVO.time uploader:file.fileVO.uploader_name file:file.fileVO.name];
        [cell setDownloaded:file.existed];
        return cell;
    } else {
        LoadMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
        cell.status = _noMoreData ? NoMore : ClickToLoad;
        return cell;
    }

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _fileList.count) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        File *file = _fileList[indexPath.row];
        if (file.existed) {
            NSURL *fileURL = [NSURL fileURLWithPath:file.localURL.absoluteString];
            UIDocumentInteractionController *dic = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
            dic.delegate = self;
            [dic presentPreviewAnimated:YES];
        } else {
            [self downloadFile:file];
        }
    } else {
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadDataWithPage:++_page];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < _fileList.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        File *file = _fileList[indexPath.row];
        [[NetworkManager sharedInstance] deleteFileWithFileId:file.fileVO.id withUserId:[UserInfo sharedInstance].id completionHandler:^(NSDictionary *response) {
            ResultVO *result = [[ResultVO alloc] initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
            if (result.success == 0) {
                [_fileList removeObject:file];
                if (_fileList.count > 0) {
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [self.tableView reloadData];
                }
                // 删除本地文件
                [file delete];
            } else {
                [ErrorHandler showErrorAlert:@"删除失败"];
            }
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
#warning deprecated api
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:imageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *imageRep = [asset defaultRepresentation];
        [self uploadImage:image name:[imageRep filename] size:[NSString stringWithFormat:@"%.2fMB", [imageRep size]/1024.0/1024.0]];
    } failureBlock:^(NSError *error) {
        
    }];
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

- (IBAction)addButtonPressed:(id)sender
{
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

@end
