//
//  Utils.m
//  CHManagement
//
//  Created by Peng, Troy on 5/10/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (BOOL)isInputPositiveInteger:(NSString*)input{
    NSScanner* scan = [NSScanner scannerWithString:input];
    NSInteger input_integer;
    BOOL success = [scan scanInteger:&input_integer];
    BOOL isAtEnd = [scan isAtEnd];
    BOOL isPositive = input_integer >= 0 ? 1 : 0;
    return success && isAtEnd && isPositive;
}

+ (BOOL)isInputPositiveDouble:(NSString*)input{
    NSScanner* scan = [NSScanner scannerWithString:input];
    double input_double;
    BOOL success = [scan scanDouble:&input_double];
    BOOL isAtEnd = [scan isAtEnd];
    BOOL isPositive = input_double >=0 ? 1 : 0;
    return success && isAtEnd && isPositive;
}

@end
