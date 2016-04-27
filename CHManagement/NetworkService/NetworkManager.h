//
//  NetworkManager.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultVO.h"
#import "RequestParameter.h"

@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)httpActionWithParameter:(RequestParameter *)parameter completionHandler:(void (^) (id responseObject))handler;
- (void)signIn:(NSString *)email password:(NSString *)password completionHandler:(void (^)(NSDictionary *))handler;
- (void)registerWithEmail:(NSString*)email withPswd:(NSString*)pswd withName:(NSString*)name withRoleId:(NSInteger)role_id withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;
@end
