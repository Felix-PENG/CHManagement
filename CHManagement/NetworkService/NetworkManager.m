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

#define TIME_OUT_SECONDS 100

#define baseUrl @"http://114.215.95.68:8080/cherp/"
#define signInUrl @"api/signIn"
#define signUpUrl @"api/signUp"
#define changePswdUrl @"api/changePswd"
#define createGroupUrl @"api/createGroup"
#define changeGroupUrl @"api/changeGroup"
#define getGroupsUrl @"api/getGroups"
#define getGroupByIdUrl @"api/getGroupById"

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

- (void)signIn:(NSString *)email password:(NSString *)password completionHandler:(void (^)(NSDictionary *))handler
{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, signInUrl];
    parameter.json = @{@"email": email, @"pswd": password};
    [self httpActionWithParameter:parameter completionHandler:handler];
}

- (void)registerWithEmail:(NSString*)email withPswd:(NSString*)pswd withName:(NSString*)name withRoleId:(NSInteger)role_id withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler{
    RequestParameter *parameter = [RequestParameter getRequest];
    parameter.url = [NSString stringWithFormat:@"%@%@", baseUrl, signUpUrl];
    parameter.json = @{@"email": email, @"pswd": pswd, @"name":name, @"role_id":[NSNumber numberWithInteger:role_id], @"group_id":[NSNumber numberWithInteger:group_id]};
    [self httpActionWithParameter:parameter completionHandler:handler];
}
@end
