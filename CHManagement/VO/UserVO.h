//
//  UserVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Role.h"
#import "MyGroup.h"
#import "AccountVO.h"
#import "JSONModel.h"

@interface UserVO : JSONModel

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,assign) NSInteger point;
@property (nonatomic,strong) Role* role;
@property (nonatomic,strong) MyGroup* group;
@property (nonatomic,strong) AccountVO* account;


@end
