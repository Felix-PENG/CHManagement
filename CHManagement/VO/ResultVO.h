//
//  ResultVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ResultVO : JSONModel

@property (nonatomic,assign) NSInteger success;

@property (nonatomic,copy) NSString* message;

@end
