//
//  MBProgressHUD+Extends.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/29.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "MBProgressHUD+Extends.h"

@implementation MBProgressHUD (Extends)

+ (void)showLoadingWithMessage:(NSString *)msg toView:(UIView *)view executing:(void (^)())executingBlock completion:(void (^)())completionBlock
{
    MBProgressHUD *hud = [self hudWithMessage:msg toView:view];
    
    [hud showAnimated:YES whileExecutingBlock:executingBlock completionBlock:completionBlock];
}

+ (void)showLoadingWithMessage:(NSString *)msg executing:(void (^)())executingBlock completion:(void (^)())completionBlock
{
    [self showLoadingWithMessage:msg toView:nil executing:executingBlock completion:completionBlock];
}

+ (MBProgressHUD *)hudWithMessage:(NSString *)msg
{
    return [self hudWithMessage:msg toView:nil];
}

+ (MBProgressHUD *)hudWithMessage:(NSString *)msg toView:(UIView *)view
{
    if (!view) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = msg; // 提示信息
    hud.removeFromSuperViewOnHide = YES; // 隐藏时从父控件中移除
    hud.dimBackground = NO; // 显示蒙板
    return hud;
}

@end
