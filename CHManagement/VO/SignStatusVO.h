//
//  SignStatusVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface SignStatusVO : JSONModel

@property (nonatomic,assign) NSInteger status;//0未签到1已签到
@property (nonatomic,assign) NSInteger continuous_sign;//连续签到天数
@property (nonatomic,assign) NSInteger point;//积分

@end
