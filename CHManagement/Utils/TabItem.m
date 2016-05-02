//
//  TabItem.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/2.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "TabItem.h"

@implementation TabItem

- (instancetype)initWithTab:(NSString *)tab controller:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        self.tabName = tab;
        self.controller = controller;
    }
    return self;
}

@end
