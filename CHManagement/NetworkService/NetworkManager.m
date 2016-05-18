//
//  NetworkManager.m
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"
#import "NetworkFile.h"
#import "NSDictionary+Extends.h"
#import "NetworkConstants.h"
#import "File.h"
#import "FileVO.h"
#import "UserInfo.h"

#define TIME_OUT_SECONDS 100

@implementation NetworkManager{
    NSOperationQueue *_queue;
}

+ (instancetype)sharedInstance
{
    static NetworkManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (void)httpActionWithParameter:(RequestParameter *)parameter completionHandler:(void (^)(id))handler
{
    NSMutableURLRequest *request;
    
    if (parameter.multiPartJson) {
        NSLog(@"multi");
        request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:parameter.httpMethod
                                                                             URLString:parameter.url
                                                                            parameters:nil
                                                             constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                 NSDictionary *fileData = parameter.multiPartJson;
                                                                 
                                                                 for (NSString *key in fileData) {
                                                                     if([fileData[key] isKindOfClass:[NSDictionary class]]){
                                                                         NetworkFile *file = [[NetworkFile alloc] initWithDictionary:fileData[key]];
                                                                         if (file != nil) {
                                                                             if(file.mineType){
                                                                                 [formData appendPartWithFileURL:[NSURL fileURLWithPath:file.filePath] name:key fileName:[file.filePath lastPathComponent] mimeType:file.mineType error:nil];
                                                                             }else{
                                                                                 [formData appendPartWithFileURL:[NSURL fileURLWithPath:file.filePath] name:key error:nil];
                                                                             }
                                                                         }
                                                                         else{
                                                                             [formData appendPartWithFormData:[[fileData[key] toJsonString] dataUsingEncoding:NSUTF8StringEncoding] name:key];
                                                                         }
                                                                     }else if([fileData[key] isKindOfClass:[NSArray class]]){
                                                                         for(NSDictionary *fileDic in fileData[key]){
                                                                             NetworkFile *file = [[NetworkFile alloc] initWithDictionary:fileDic];
                                                                             if (file != nil) {
                                                                                 if(file.mineType){
                                                                                     [formData appendPartWithFileURL:[NSURL fileURLWithPath:file.filePath] name:key fileName:[file.filePath lastPathComponent] mimeType:file.mineType error:nil];
                                                                                 }else{
                                                                                     [formData appendPartWithFileURL:[NSURL fileURLWithPath:file.filePath] name:key error:nil];
                                                                                 }
                                                                             }else{
                                                                                 [formData appendPartWithFormData:[[fileDic toJsonString] dataUsingEncoding:NSUTF8StringEncoding] name:key];
                                                                             }
                                                                             
                                                                         }
                                                                     } else {
                                                                         [formData appendPartWithFormData:[fileData[key] dataUsingEncoding:NSUTF8StringEncoding] name:key];
                                                                     }
                                                                 }
                                                             }
                                                                                 error:nil];
        
    }else{
        UserInfo *userInfo = [UserInfo sharedInstance];
        NSString* token = userInfo.token;
        NSInteger token_user_id = userInfo.tokenUserId;
        NSMutableDictionary* json = [NSMutableDictionary dictionary];
        [json addEntriesFromDictionary:parameter.json];
        
        if (token) {
            [json setObject:token forKey:@"token"];
        }
        if(@(token_user_id)){
            [json setObject:[NSNumber numberWithInteger:token_user_id] forKey:@"token_user_id"];
        }
        request = [[AFHTTPRequestSerializer serializer] requestWithMethod:parameter.httpMethod
                                                                URLString:parameter.url
                                                               parameters:json
                                                                    error:nil
                   ];
    }
    
    for (NSString *key in parameter.header) {
        if (![[parameter.header valueForKey:key] isEqualToString:HEADER_MULTI]) {
            [request setValue:[parameter.header valueForKey:key] forHTTPHeaderField:key];
        }
    }
    request.timeoutInterval = TIME_OUT_SECONDS;
    [request setValue:@"iOS" forHTTPHeaderField:@"From"];
    
    
   // NSString *token_user_id = [userData objectForKey:@"token_user_id"];
    //NSLog(@"token_user_id:%@",token_user_id);
    //if (token_user_id) {
        //[request setValue:token_user_id forHTTPHeaderField:@"token_user_id"];
        //[request setValue:token_user_id forKey:@"token_user_id"];
    //}
    
    NSLog(@"%@", request.allHTTPHeaderFields);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:HEADER_TEXT,HEADER_SINGER,HEADER_JS, nil];
    
    [operation
     setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
         [self completeTask];
         handler(responseObject);
     }
     failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         [self completeTask];
         NSLog(@"Network error, %@", error);
         handler(nil);
         [self showNetworkError];
     }];
    
    [_queue addOperation:operation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)downloadWithParameter:(RequestParameter *)parameter savePath:(NSString *)savePath success:(void (^)(id))success failure:(void (^)(NSError *))failure progress:(void (^)(float))progress
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:parameter.httpMethod
                                                                                 URLString:parameter.url
                                                                                parameters:parameter.json
                                                                                     error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    request.timeoutInterval = TIME_OUT_SECONDS;
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savePath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = totalBytesRead / totalBytesExpectedToRead;
        progress(p);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"下载成功");
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"Download error: %@", error);
        failure(error);
    }];
    
    [_queue addOperation:operation];
}

- (void)completeTask
{
    if ([_queue operationCount] == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)showNetworkError
{
}

#pragma mark Account api
- (void)signIn:(NSString *)email pswd:(NSString *)pswd completionHandler:(void (^)(NSDictionary *))handler
{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, signInUrl];
    parameter.json = @{@"email": email, @"pswd": pswd};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)registerWithEmail:(NSString*)email withPswd:(NSString*)pswd withName:(NSString*)name withRoleId:(NSInteger)role_id withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, signUpUrl];
    parameter.json = @{@"email": email, @"pswd": pswd, @"name":name, @"role_id":[NSNumber numberWithInteger:role_id], @"group_id":[NSNumber numberWithInteger:group_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changePswd:(NSString*)pswd withNewPswd:(NSString*)n_pswd withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changePswdUrl];
    parameter.json = @{@"pswd": pswd, @"n_pswd": n_pswd, @"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark Group api
- (void)createGroupWithName:(NSString*)name completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createGroupUrl];
    parameter.json = @{@"name": name};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeGroupName:(NSString*)name withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeGroupUrl];
    parameter.json = @{@"name": name, @"group_id":[NSNumber numberWithInteger:group_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getGroupsByUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getGroupsByUserIdURL];
    parameter.json = @{@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getGroupWithGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getGroupByIdUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteGroupWithGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteGroupUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getAllGroupsWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getGroupsUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark Role api
- (void)createRoleAndPermissionWithName:(NSString*)name withPermissionList:(NSString*)permission_list completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createRoleAndPermissionUrl];
    parameter.json = @{@"name":name,@"permission_list":permission_list};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteRoleWithRoleId:(NSInteger)role_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteRoleUrl];
    parameter.json = @{@"role_id":[NSNumber numberWithInteger:role_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];

}

- (void)changeRoleWithRoleId:(NSInteger)role_id withName:(NSString*)name completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeRoleUrl];
    parameter.json = @{@"role_id":[NSNumber numberWithInteger:role_id],@"name":name};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getRolesWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getRolesUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getRolesWithRoleId:(NSInteger)role_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getRolesByIdUrl];
    parameter.json = @{@"role_id":[NSNumber numberWithInteger:role_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getRolePermissionWithRoleId:(NSInteger)role_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getRolePermissionByRoleIdUrl];
    parameter.json = @{@"role_id":[NSNumber numberWithInteger:role_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeRolePermissionWithRoleId:(NSInteger)role_id withPermissionList:(NSString*)permission_list completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeRolePermissionUrl];
    parameter.json = @{@"role_id":[NSNumber numberWithInteger:role_id],@"permission_list":permission_list};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark Permission api
- (void)getPermissionsWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getPermissionsUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark User api
- (void)getUsersWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getUsersUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getUserById:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getUserByIdUrl];
    parameter.json = @{@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteUserById:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteUserUrl];
    parameter.json = @{@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeUserWithName:(NSString*)name withRoleId:(NSInteger)role_id withGroupId:(NSInteger)group_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeUserUrl];
    parameter.json = @{@"name":name,@"role_id":[NSNumber numberWithInteger:role_id],@"group_id":[NSNumber numberWithInteger:group_id],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
    
}

#pragma mark Sign api
- (void)signByUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, signUrl];
    parameter.json = @{@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}


- (void)getSignStatusByUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getSignStatusUrl];
    parameter.json = @{@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark File api
- (void)createFileWithName:(NSString*)name withSize:(NSString*)size withUrl:(NSString*)url withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createFileUrl];
    parameter.json = @{@"name":name,@"size":size,@"url":url,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getUploadTokenWithName:(NSString*)name withKeyPre:(NSString*)key_pre completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getUploadTokenUrl];
    parameter.json = @{@"name":name,@"key_pre":key_pre};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteFileWithFileId:(NSInteger)file_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteFileUrl];
    parameter.json = @{@"file_id":[NSNumber numberWithInteger:file_id],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getFilesWithPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getFilesUrl];
    parameter.json = @{@"page":[NSNumber numberWithInteger:page]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)downloadFile:(File *)file success:(void (^)(id))success failure:(void (^)(NSError *))failure progress:(void (^)(float))progress
{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = file.fileVO.url;
    [self downloadWithParameter:parameter
                       savePath:file.localURL.absoluteString
                        success:success
                        failure:failure
                       progress:progress];
}

#pragma mark Message api
- (void)createMessageWithIdList:(NSString*)id_list withContent:(NSString*)content withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createMessageUrl];
    parameter.json = @{@"id_list":id_list,@"content":content,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteMessageWithMessageId:(NSInteger)message_id withInOff:(NSInteger)in_off withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteMessageUrl];
    parameter.json = @{@"message_id":[NSNumber numberWithInteger:message_id],@"in_off":[NSNumber numberWithInteger:in_off],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getMessagesWithPage:(NSInteger)page withInOff:(NSInteger)in_off withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getMessagesUrl];
    parameter.json = @{@"page":[NSNumber numberWithInteger:page],@"in_off":[NSNumber numberWithInteger:in_off],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark Activity api
- (void)createActivityWithGroupId:(NSInteger)group_id withContent:(NSString*)content withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createActivityUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"content":content,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getActivitiesByGroupId:(NSInteger)group_id withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getActivitiesByGroupIdUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"page":[NSNumber numberWithInteger:page]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeActivityWithActivityId:(NSInteger)activity_id withContent:(NSString*)content withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeActivityUrl];
    parameter.json = @{@"activity_id":[NSNumber numberWithInteger:activity_id],@"content":content,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getActivityById:(NSInteger)activity_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getActivityByIdUrl];
    parameter.json = @{@"activity_id":[NSNumber numberWithInteger:activity_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getYesterdayActivityWithGroupId:(NSInteger)group_id withActivityId:(NSInteger)activity_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getYesterdayActivityByIdUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"activity_id":[NSNumber numberWithInteger:activity_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getYesterdayActivityByGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getYesterActivityUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark Schedule api
- (void)createScheduleWithYesterday:(NSString*)yst withToday:(NSString*)tdy withTomorrow:(NSString*)tmw withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createScheduleUrl];
    parameter.json = @{@"yesterday":yst,@"today":tdy,@"tomorrow":tmw,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeScheduleWithId:(NSInteger)schedule_id withYesterday:(NSString*)yst withToday:(NSString*)tdy withTomorrow:(NSString*)tmw completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeScheduleUrl];
    parameter.json = @{@"schedule_id":[NSNumber numberWithInteger:schedule_id],@"yesterday":yst,@"today":tdy,@"tomorrow":tmw};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getSchedulesWithPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getSchedulesUrl];
    parameter.json = @{@"page":[NSNumber numberWithInteger:page],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getScheduleById:(NSInteger)schedule_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getScheduleByIdUrl];
    parameter.json = @{@"schedule_id":[NSNumber numberWithInteger:schedule_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getYesterdayScheduleByUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getYesterdayScheduleUrl];
    parameter.json = @{@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getYesterdayScheduleById:(NSInteger)schedule_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getYesterdayScheduleByIdUrl];
    parameter.json = @{@"schedule_id":[NSNumber numberWithInteger:schedule_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark AuditMaterials api
- (void)createAuditMaterialsWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withType:(NSString*)type withUnitPrice:(double)unit_price withNum:(NSInteger)num withIn_off:(NSInteger)in_off withDealerName:(NSString*)dealer_name withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createAuditMaterialsUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"name":name,@"type":type,@"unit_price":[NSNumber numberWithDouble:unit_price],@"num":[NSNumber numberWithInteger:num],@"in_off":[NSNumber numberWithInteger:in_off],@"dealer_name":dealer_name,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeAuditMaterialsWithId:(NSInteger)auditMaterials_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name  withType:(NSString*)type withUnitPrice:(double)unit_price withNum:(NSInteger)num withIn_off:(NSInteger)in_off withDealerName:(NSString*)dealer_name withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeAuditMaterialsUrl];
    parameter.json = @{@"auditMaterials_id":[NSNumber numberWithInteger:auditMaterials_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"name":name,@"type":type,@"unit_price":[NSNumber numberWithDouble:unit_price],@"num":[NSNumber numberWithInteger:num],@"in_off":[NSNumber numberWithInteger:in_off],@"dealer_name":dealer_name,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
    
}

- (void)deleteAuditMaterialsWithId:(NSInteger)auditMaterials_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteAuditMaterialsUrl];
    parameter.json = @{@"auditMaterials_id":[NSNumber numberWithInteger:auditMaterials_id],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getAuditMaterialsListWithStatus:(NSInteger)audit_status withIn_off:(NSInteger)in_off withPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getAuditMaterialsListByStatusAndIn_offUrl];
    parameter.json = @{@"audit_status":[NSNumber numberWithInteger:audit_status],@"in_off":[NSNumber numberWithInteger:in_off],@"page":[NSNumber numberWithInteger:page],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getAuditMaterialsListWithGroupId:(NSInteger)group_id withStatus:(NSInteger)audit_status withIn_off:(NSInteger)in_off withPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getAuditMaterialsListByGroupIdAndStatusAndIn_offUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"audit_status":[NSNumber numberWithInteger:audit_status],@"in_off":[NSNumber numberWithInteger:in_off],@"page":[NSNumber numberWithInteger:page],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getAuditMaterialsById:(NSInteger)auditMaterials_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getAuditMaterialsByIdUrl];
    parameter.json = @{@"auditMaterials_id":[NSNumber numberWithInteger:auditMaterials_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)auditAuditMaterialsWithId:(NSInteger)auditMaterials_id withStatus:(NSInteger)audit_status withReason:(NSString*)reason completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, auditAuditMaterialsUrl];
    parameter.json = @{@"auditMaterials_id":[NSNumber numberWithInteger:auditMaterials_id],@"audit_status":[NSNumber numberWithInteger:audit_status],@"reason":reason};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark AuditOthers api
- (void)createAuditOthersWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withUnitPrice:(double)unit_price withNum:(NSInteger)num withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createAuditOthersUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"name":name,@"unit_price":[NSNumber numberWithDouble:unit_price],@"num":[NSNumber numberWithInteger:num],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeAuditOthersWithId:(NSInteger)auditOthers_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withUnitPrice:(double)unit_price withNum:(NSInteger)num withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeAuditOthersUrl];
    parameter.json = @{@"auditOthers_id":[NSNumber numberWithInteger:auditOthers_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"name":name,@"unit_price":[NSNumber numberWithDouble:unit_price],@"num":[NSNumber numberWithInteger:num],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteAuditOthersWithId:(NSInteger)auditOthers_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteAuditOthersUrl];
    parameter.json = @{@"auditOthers_id":[NSNumber numberWithInteger:auditOthers_id], @"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getAuditOthersListWithStatus:(NSInteger)audit_status withPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getAuditOthersListByStatusUrl];
    parameter.json = @{@"audit_status":[NSNumber numberWithInteger:audit_status],@"page":[NSNumber numberWithInteger:page],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getAuditOthersListWithGroupId:(NSInteger)group_id withStatus:(NSInteger)audit_status withPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getAuditOthersListByGroupIdAndStatusUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"audit_status":[NSNumber numberWithInteger:audit_status],@"page":[NSNumber numberWithInteger:page],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getAuditOthersById:(NSInteger)auditOthers_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getAuditOthersByIdUrl];
    parameter.json = @{@"auditOthers_id":[NSNumber numberWithInteger:auditOthers_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)auditAuditOthersWithId:(NSInteger)auditOthers_id withStatus:(NSInteger)audit_status withReason:(NSString*)reason completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, auditAuditOthersUrl];
    parameter.json = @{@"auditOthers_id":[NSNumber numberWithInteger:auditOthers_id],@"audit_status":[NSNumber numberWithInteger:audit_status],@"reason":reason};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark Bill api
- (void)createBillWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withIn_off:(NSInteger)in_off withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createBillUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"in_off":[NSNumber numberWithInteger:in_off],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeBillWithId:(NSInteger)bill_id withContent:(NSString*)content withMoney:(double)money withIn_off:(NSInteger)in_off withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeBillUrl];
    parameter.json = @{@"bill_id":[NSNumber numberWithInteger:bill_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"in_off":[NSNumber numberWithInteger:in_off],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
    
}

- (void)getBillById:(NSInteger)bill_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getBillByIdUrl];
    parameter.json = @{@"bill_id":[NSNumber numberWithInteger:bill_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getBillsWithGroupId:(NSInteger)group_id withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getBillsByGroupIdUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"page":[NSNumber numberWithInteger:page]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark BillBuilding api
- (void)createBillBuildingWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withPurName:(NSString*)purchaser_name withPurPhone:(NSString*)purchaser_phone withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createBillBuildingUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"purchaser_name":purchaser_name,@"purchaser_phone":purchaser_phone,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeBillBuildingWithId:(NSInteger)billBuilding_id withContent:(NSString*)content withMoney:(double)money withPurName:(NSString*)purchaser_name withPurPhone:(NSString*)purchaser_phone withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeBillBuildingUrl];
    parameter.json = @{@"billBuilding_id":[NSNumber numberWithInteger:billBuilding_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"purchaser_name":purchaser_name,@"purchaser_phone":purchaser_phone,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getBillBuildingById:(NSInteger)billBuilding_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getBillBuildingByIdUrl];
    parameter.json = @{@"billBuilding_id":[NSNumber numberWithInteger:billBuilding_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getBillBuildingsWithGroupId:(NSInteger)group_id withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getBillBuildingsByGroupIdUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"page":[NSNumber numberWithInteger:page]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark BillMaterials api
- (void)createBillMaterialsWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withType:(NSString*)type withUnitPrice:(double)unit_price withNum:(NSInteger)num withIn_off:(NSInteger)in_off withDealerName:(NSString*)dealer_name withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createBillMaterialsUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"name":name,@"type":type,@"unit_price":[NSNumber numberWithDouble:unit_price],@"num":[NSNumber numberWithInteger:num],@"in_off":[NSNumber numberWithInteger:in_off],@"dealer_name":dealer_name,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeBillMaterialsWithId:(NSInteger)billMaterials_id withGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withType:(NSString*)type withUnitPrice:(double)unit_price withNum:(NSInteger)num withIn_off:(NSInteger)in_off withDealerName:(NSString*)dealer_name withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeBillMaterialsUrl];
    parameter.json = @{@"billMaterials_id":[NSNumber numberWithInteger:billMaterials_id],@"group_id":[NSNumber numberWithInteger:group_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"name":name,@"type":type,@"unit_price":[NSNumber numberWithDouble:unit_price],@"num":[NSNumber numberWithInteger:num],@"in_off":[NSNumber numberWithInteger:in_off],@"dealer_name":dealer_name,@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteBillMaterialsWithId:(NSInteger)billMaterials_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteBillMaterialsUrl];
    parameter.json = @{@"billMaterials_id":[NSNumber numberWithInteger:billMaterials_id],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getBillMaterialsListWithGroupId:(NSInteger)group_id withStatus:(NSInteger)finish_status withIn_off:(NSInteger)in_off withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getBillMeterialsListByGroupIdAndStatusAndIn_offUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"finish_status":[NSNumber numberWithInteger:finish_status],@"in_off":[NSNumber numberWithInteger:in_off],@"page":[NSNumber numberWithInteger:page]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getBillMaterialsById:(NSInteger)billMaterials_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getBillMaterialsByIdUrl];
    parameter.json = @{@"billMaterials_id":[NSNumber numberWithInteger:billMaterials_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)finishBillMaterialsWithId:(NSInteger)billMaterials_id withStatus:(NSInteger)finish_status withUrl:(NSString*)url completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, finishBillMaterialsUrl];
    parameter.json = @{@"billMaterials_id":[NSNumber numberWithInteger:billMaterials_id],@"finish_status":[NSNumber numberWithInteger:finish_status],@"url":url};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma mark BillOthers api
- (void)changeBillOthersWithId:(NSInteger)billOthers_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withUnitPrice:(double)unit_price withNum:(NSInteger)num withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeBillOthersUrl];
    parameter.json = @{@"billOthers_id":[NSNumber numberWithInteger:billOthers_id],@"content":content,@"money":[NSNumber numberWithDouble:money],@"name":name,@"unit_price":[NSNumber numberWithDouble:unit_price],@"num":[NSNumber numberWithInteger:num],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteBillOthersWithId:(NSInteger)billOthers_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteBillOthersUrl];
    parameter.json = @{@"billOthers_id":[NSNumber numberWithInteger:billOthers_id],@"user_id":[NSNumber numberWithInteger:user_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getBillOthersListByStatus:(NSInteger)finish_status completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getBillOthersListByStatusUrl];
    parameter.json = @{@"finish_status":[NSNumber numberWithInteger:finish_status]};
    [self httpActionWithParameter:parameter completionHandler:handler];
    
}

- (void)getBillOthersListWithGroupId:(NSInteger)group_id withStatus:(NSInteger)finish_status withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getBillOthersListByGroupIdAndStatusUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"finish_status":[NSNumber numberWithInteger:finish_status],@"page":[NSNumber numberWithInteger:page]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getBillOthersById:(NSInteger)billOthers_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getBillOthersByIdUrl];
    parameter.json = @{@"billOthers_id":[NSNumber numberWithInteger:billOthers_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)finishBillOthersWithId:(NSInteger)billOthers_id withStatus:(NSInteger)finish_status withUrl:(NSString*)url completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, finishBillOthersUrl];
    parameter.json = @{@"billOthers_id":[NSNumber numberWithInteger:billOthers_id],@"finish_status":[NSNumber numberWithInteger:finish_status],@"url":url};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)setDeviceToken:(NSUInteger)userId token:(NSString *)token completionHandler:(void (^)(NSDictionary *))handler
{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, setDeviceTokenUrl];
    parameter.json = @{@"user_id" : @(userId), @"notify_token": token};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteDeviceToken:(NSUInteger)userId completionHandler:(void (^)(NSDictionary *))handler
{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteDeviceTokenUrl];
    parameter.json = @{@"user_id" : @(userId)};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

@end
