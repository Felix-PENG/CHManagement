//
//  MBProgressHUD+Extends.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/29.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extends)

+ (MBProgressHUD *)progressHudWithMessage:(NSString *)msg;

+ (MBProgressHUD *)progressHudWithMessage:(NSString *)msg toView:(UIView *)view;

+ (MBProgressHUD *)hudWithMessage:(NSString *)msg;

+ (MBProgressHUD *)hudWithMessage:(NSString *)msg toView:(UIView *)view;

+ (void)showLoadingWithMessage:(NSString *)msg toView:(UIView *)view executing:(void (^)())executingBlock completion:(void (^)())completionBlock;

+ (void)showLoadingWithMessage:(NSString *)msg executing:(void (^)())executingBlock completion:(void (^)())completionBlock;

+ (void)showSuccessWithMessage:(NSString*)message toView:(UIView*)view completion:(void (^)())completionBlock;

@end
