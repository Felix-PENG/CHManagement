//
//  QiNiuVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface QiNiuVO : JSONModel

@property (nonatomic,copy) NSString* token;
@property (nonatomic,copy) NSString* key;

@end
