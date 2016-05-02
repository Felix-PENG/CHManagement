//
//  TabItem.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/2.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TabItem : NSObject

@property (nonatomic, copy) NSString *tabName;
@property (nonatomic, strong) UIViewController *controller;

- (instancetype)initWithTab:(NSString *)tab controller:(UIViewController *)controller;

@end
