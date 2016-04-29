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
        request = [[AFHTTPRequestSerializer serializer] requestWithMethod:parameter.httpMethod
                                                                URLString:parameter.url
                                                               parameters:parameter.json
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
    
    NSString *token = nil;   //need to add here
    if (token) {
        [request setValue:token forHTTPHeaderField:@"token"];
    }
    
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

- (void)completeTask
{
    if ([_queue operationCount] == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)showNetworkError
{
}

#pragma account api
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

- (void)changePswd:(NSString*)pswd withNewPswd:(NSString*)n_pswd completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changePswdUrl];
    parameter.json = @{@"pswd": pswd, @"n_pswd": n_pswd};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma group api
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

- (void)getGroupsByUserIdWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getGroupsByUserIdURL];
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

#pragma role api
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

#pragma permission api
- (void)getPermissionsWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getPermissionsUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma user api
- (void)getUsersWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getUsersUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getUserByUserIdWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getUserByIdUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteUserByUserIdWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteUserUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changUserWithName:(NSString*)name withRoleId:(NSInteger)role_id withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeUserUrl];
    parameter.json = @{@"name":name,@"role_id":[NSNumber numberWithInteger:role_id],@"group_id":[NSNumber numberWithInteger:group_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
    
}

#pragma sign api
- (void)signWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, signUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}


- (void)getSignStatusWithCompletionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getSignStatusUrl];
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma file api
- (void)createFileWithName:(NSString*)name withSize:(NSString*)size withUrl:(NSString*)url completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createFileUrl];
    parameter.json = @{@"name":name,@"size":size,@"url":url};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getUploadTokenWithName:(NSString*)name withKeyPre:(NSString*)key_pre completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getUploadTokenUrl];
    parameter.json = @{@"name":name,@"key_pre":key_pre};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteFileByFileId:(NSInteger)file_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteFileUrl];
    parameter.json = @{@"file_id":[NSNumber numberWithInteger:file_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getFilesWithPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getFilesUrl];
    parameter.json = @{@"page":[NSNumber numberWithInteger:page]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma message_api
- (void)createMessageWithIdList:(NSString*)id_list withContent:(NSString*)content completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createMessageUrl];
    parameter.json = @{@"id_list":id_list};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)deleteMessageWithMessageId:(NSInteger)message_id withInOff:(NSInteger)in_off completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, deleteMessageUrl];
    parameter.json = @{@"message_id":[NSNumber numberWithInteger:message_id],@"in_off":[NSNumber numberWithInteger:in_off]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getMessagesWithPage:(NSInteger)page withInOff:(NSInteger)in_off completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getMessagesUrl];
    parameter.json = @{@"page":[NSNumber numberWithInteger:page],@"in_off":[NSNumber numberWithInteger:in_off]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

#pragma activity api
- (void)createActivityWithGroupId:(NSInteger)group_id withContent:(NSString*)content completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, createActivityUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"content":content};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)getActivitiesByGroupId:(NSInteger)group_id withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, getActivitiesByGroupIdUrl];
    parameter.json = @{@"group_id":[NSNumber numberWithInteger:group_id],@"page":[NSNumber numberWithInteger:page]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)changeActivityWithActivityId:(NSInteger)activity_id withContent:(NSString*)content completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, changeActivityUrl];
    parameter.json = @{@"activity_id":[NSNumber numberWithInteger:activity_id],@"content":content};
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




@end
