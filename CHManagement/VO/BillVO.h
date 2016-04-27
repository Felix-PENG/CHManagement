//
//  BillVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyGroup.h"
#import "UserShortVO.h"
#import "JSONModel.h"

@interface BillVO : JSONModel

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,copy) NSString* detail;
@property (nonatomic,strong) MyGroup* group;
@property (nonatomic,strong) UserShortVO* user;
@property (nonatomic,assign) double money;	// 总价
@property (nonatomic,assign) NSInteger in_off;//0出账1入账

@end
