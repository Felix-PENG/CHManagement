//
//  SignInResultVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserVO.h"
#import "JSONModel.h"

@interface SignInResultVO : JSONModel

@property NSString* token;
@property UserVO* user;

@end
