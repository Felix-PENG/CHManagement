//
//  UserInfo.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/14.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "UserInfo.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "SignInResultVO.h"

#define EXPIRE_DAY 7

static BOOL signedIn = NO;

static NSString * const UserInfoKey = @"user_info";
static NSString * const UserIdKey = @"user_id";
static NSString * const TokenUserIdKey = @"token_user_id";
static NSString * const TokenKey = @"token";
static NSString * const GroupIdKey = @"group_id";
static NSString * const RoleIdKey = @"role_id";
static NSString * const UserNameKey = @"user_name";
static NSString * const CreditKey = @"credit";
static NSString * const LastSignInKey = @"last_sign_in";

@implementation UserInfo

+ (instancetype)sharedInstance
{
    static UserInfo *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [UserInfo currentInstance];
    });
    if (signedIn) { // 重新登录过，则重新读取
        signedIn = NO;
        _sharedManager = [UserInfo currentInstance];
    }
    return _sharedManager;
}

+ (void)signIn:(NSString *)userName password:(NSString *)password success:(void (^)())successHandler error:(void (^)(NSString *))errorHandler
{
    [[NetworkManager sharedInstance] signIn:userName pswd:password completionHandler:^(NSDictionary * response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        NSLog(@"%@",[resultVO message]);
        
        if (resultVO.success == 0) {
            SignInResultVO* signResultVO = [[SignInResultVO alloc]initWithDictionary:[response objectForKey:@"signInResultVO"] error:nil];
            
            UserInfo *userInfo = [[UserInfo alloc] init];
            userInfo.id = signResultVO.user.id;
            userInfo.tokenUserId = signResultVO.user.id;
            userInfo.token = signResultVO.token;
            userInfo.groupId = signResultVO.user.group.id;
            userInfo.roleId = signResultVO.user.role.id;
            userInfo.userName = signResultVO.user.name;
            userInfo.credit = signResultVO.user.point;
            userInfo.lastSignIn = [[NSDate date] timeIntervalSince1970];
            [UserInfo remove];
            [userInfo persist];
            signedIn = YES;
            
            successHandler();
        } else {
            errorHandler(resultVO.message);
        }
    }];
}

+ (UserInfo *)currentInstance
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey];
    UserInfo *userInfo = (UserInfo *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return userInfo.expired ? nil : userInfo;
}

- (BOOL)expired
{
    NSDate *lastSignInDate = [NSDate dateWithTimeIntervalSince1970:self.lastSignIn];
    return [[NSDate date] timeIntervalSinceDate:lastSignInDate] > EXPIRE_DAY * 24 * 60 * 60;
}

- (void)persist
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:UserInfoKey];
    [userDefaults synchronize];
}

+ (void)remove
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserInfoKey];
}

#pragma mark - Coder

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.id = [[aDecoder decodeObjectForKey:UserIdKey] integerValue];
        self.tokenUserId = [[aDecoder decodeObjectForKey:TokenUserIdKey] integerValue];
        self.token = [aDecoder decodeObjectForKey:TokenKey];
        self.groupId = [[aDecoder decodeObjectForKey:GroupIdKey] integerValue];
        self.roleId = [[aDecoder decodeObjectForKey:RoleIdKey] integerValue];
        self.credit = [[aDecoder decodeObjectForKey:CreditKey] integerValue];
        self.userName = [aDecoder decodeObjectForKey:UserNameKey];
        self.lastSignIn = [[aDecoder decodeObjectForKey:LastSignInKey] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.id) forKey:UserIdKey];
    [aCoder encodeObject:@(self.tokenUserId) forKey:TokenUserIdKey];
    [aCoder encodeObject:self.token forKey:TokenKey];
    [aCoder encodeObject:@(self.groupId) forKey:GroupIdKey];
    [aCoder encodeObject:@(self.roleId) forKey:RoleIdKey];
    [aCoder encodeObject:@(self.credit) forKey:CreditKey];
    [aCoder encodeObject:self.userName forKey:UserNameKey];
    [aCoder encodeObject:@(self.lastSignIn) forKey:LastSignInKey];
}

@end
