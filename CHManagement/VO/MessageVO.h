//
//  MessageVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserShortVO.h"
#import "JSONModel.h"

@interface MessageVO : JSONModel

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger in_off;
@property (nonatomic,strong) UserShortVO* sender;
@property (nonatomic,strong) NSArray<UserShortVO>* receivers;
@property (nonatomic,copy) NSString* content;
@property (nonatomic,assign) NSInteger time;

@end
