//
//  ScheduleVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ScheduleVO : JSONModel

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,copy) NSString* yesterday;
@property (nonatomic,copy) NSString* today;
@property (nonatomic,copy) NSString* tomorrow;

@end
