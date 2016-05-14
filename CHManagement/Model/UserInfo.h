//
//  UserInfo.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/14.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger tokenUserId;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,assign) NSInteger groupId;
@property (nonatomic,assign) NSInteger roleId;
@property (nonatomic,assign) NSInteger credit;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,assign) NSTimeInterval lastSignIn;

+ (void)signIn:(NSString *)userName password:(NSString *)password success:(void (^)())successHandler error:(void (^)(NSString *))errorHandler;

+ (instancetype)sharedInstance;

- (void)persist;

+ (void)remove;

- (BOOL)expired;

@end
