//
//  BillMaterialsVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyGroup.h"
#import "UserShortVO.h"
#import "JSONModel.h"

@interface BillMaterialsVO : JSONModel

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,copy) NSString* detail;
@property (nonatomic,strong) MyGroup* group;
@property (nonatomic,strong) UserShortVO* user;
@property (nonatomic,assign) NSInteger finish_status;
// 总价
@property (nonatomic,assign) double money;
@property (nonatomic,copy) NSString* url;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* type;
// 单价
@property (nonatomic,assign) double unit_price;
@property (nonatomic,assign) NSInteger num;
// 买入还是卖出
@property (nonatomic,assign) NSInteger in_off;
// 交易者信息
@property (nonatomic,copy) NSString* dealer_name;

@end
