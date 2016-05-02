//
//  IDEntity.h
//  CHManagement
//
//  Created by Peng, Troy on 5/1/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface IDEntity : JSONModel

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger delete_flag;

@end
