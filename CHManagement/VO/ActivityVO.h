//
//  ActivityVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserShortVO.h"
#import "JSONModel.h"

@interface ActivityVO : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) UserShortVO* user;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic,copy) NSString* detail;
@property (nonatomic,copy) NSString* group_name;

@end
