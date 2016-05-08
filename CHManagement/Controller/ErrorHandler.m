//
//  ErrorHandler.m
//  CHManagement
//
//  Created by Peng, Troy on 5/7/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

#pragma error handler
+ (UIAlertController*)showErrorAlert:(NSString*)message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    return alert;
}

@end
