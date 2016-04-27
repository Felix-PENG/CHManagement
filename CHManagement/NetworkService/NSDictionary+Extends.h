//
//  NSDictionary+Extends.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extends)

-(NSString *)toJsonString;


+(NSMutableDictionary *)dicRemoveNull:(id)dic;

- (id)nonNullObjectForKey:(id)aKey;

@end
