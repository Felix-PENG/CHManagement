//
//  RequestParameter.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HEADER_SINGER   @"application/json"
#define HEADER_MULTI    @"multipart/form-data"
#define HEADER_TEXT     @"text/html"
#define HEADER_JS       @"text/javascript"
#define HEADER_DEFAULT  @"application/x-www-form-urlencoded"

#define HEADER_CONTENT_TYPE @"Content-type"
#define HEADER_BOUNDARY     @"boundary"
#define HEADER_X_TOKEN      @"X-Auth-Token"

#define METHOD_POST @"POST"
#define METHOD_GET  @"GET"
#define METHOD_PUT  @"PUT"
#define METHOD_DELETE @"DELETE"

@interface RequestParameter : NSObject

@property(nonatomic,copy) NSString *httpMethod;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSDictionary *json;
@property(nonatomic,copy) NSDictionary *multiPartJson;
@property(nonatomic,copy) NSDictionary *header;
@property(nonatomic,assign) BOOL needResend;

+(instancetype)postRequest;

+(instancetype)multiPartRequest;

+(instancetype)getRequest;

+(instancetype)putRequest;

+(instancetype)deleteRequest;

-(void)setUrl:(NSString *)url withParam:(NSDictionary *)dic;

@end
