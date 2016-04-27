//
//  NetworkFile.m
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "NetworkFile.h"

@implementation NetworkFile

-(instancetype)init{
    self = [super init];
    if (self) {
        self.filePath = @"";
        self.mineType = @"";
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    NSError *error;
    self = [super initWithDictionary:dict error:&error];
    if (self && !error) {
        return self;
    }
    return nil;
}

@end
