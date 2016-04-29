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

#pragma account api
- (void)signIn:(NSString *)email pswd:(NSString *)pswd completionHandler:(void (^)(NSDictionary *))handler;

- (void)registerWithEmail:(NSString*)email withPswd:(NSString*)pswd withName:(NSString*)name withRoleId:(NSInteger)role_id withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changePswd:(NSString*)pswd withNewPswd:(NSString*)n_pswd completionHandler:(void (^)(NSDictionary *))handler;

#pragma group api
- (void)createGroupWithName:(NSString*)name completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeGroupName:(NSString*)name withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getAllGroupsWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)getGroupWithGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteGroupWithGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getGroupsByUserIdWithCompletionHandler:(void (^)(NSDictionary *))handler;

#pragma role api
- (void)createRoleAndPermissionWithName:(NSString*)name withPermissionList:(NSString*)permission_list completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteRoleWithRoleId:(NSInteger)role_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeRoleWithRoleId:(NSInteger)role_id withName:(NSString*)name completionHandler:(void (^)(NSDictionary *))handler;

- (void)getRolesWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)getRolesWithRoleId:(NSInteger)role_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getRolePermissionWithRoleId:(NSInteger)role_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeRolePermissionWithRoleId:(NSInteger)role_id withPermissionList:(NSString*)permission_list completionHandler:(void (^)(NSDictionary *))handler;

#pragma permission api
- (void)getPermissionsWithCompletionHandler:(void (^)(NSDictionary *))handler;

#pragma user api
- (void)getUsersWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)getUserByUserIdWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteUserByUserIdWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)changUserWithName:(NSString*)name withRoleId:(NSInteger)role_id withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

#pragma sign api
- (void)signWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)getSignStatusWithCompletionHandler:(void (^)(NSDictionary *))handler;

#pragma file api
- (void)createFileWithName:(NSString*)name withSize:(NSString*)size withUrl:(NSString*)url completionHandler:(void (^)(NSDictionary *))handler;

- (void)getUploadTokenWithName:(NSString*)name withKeyPre:(NSString*)key_pre completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteFileByFileId:(NSInteger)file_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getFilesWithPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler;

#pragma message_api
- (void)createMessageWithIdList:(NSString*)id_list withContent:(NSString*)content completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteMessageWithMessageId:(NSInteger)message_id withInOff:(NSInteger)in_off completionHandler:(void (^)(NSDictionary *))handler;

- (void)getMessagesWithPage:(NSInteger)page withInOff:(NSInteger)in_off completionHandler:(void (^)(NSDictionary *))handler;

#pragma activity api
- (void)createActivityWithGroupId:(NSInteger)group_id withContent:(NSString*)content completionHandler:(void (^)(NSDictionary *))handler;

- (void)getActivitiesByGroupId:(NSInteger)group_id withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeActivityWithActivityId:(NSInteger)activity_id withContent:(NSString*)content completionHandler:(void (^)(NSDictionary *))handler;

- (void)getActivityById:(NSInteger)activity_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getYesterdayActivityWithGroupId:(NSInteger)group_id withActivityId:(NSInteger)activity_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getYesterdayActivityByGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

#pragma schedule api

@end
