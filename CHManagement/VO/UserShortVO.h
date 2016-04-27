//
//  UserShortVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol UserShortVO

@end

@interface UserShortVO : JSONModel

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy) NSString* name;

@end
