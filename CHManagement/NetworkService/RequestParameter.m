//
//  RequestParameter.m
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "RequestParameter.h"

@implementation RequestParameter

+(instancetype)postRequest{
    RequestParameter *parameter = [[self alloc] init];
    parameter.header = @{HEADER_CONTENT_TYPE:HEADER_DEFAULT};
    parameter.httpMethod = METHOD_POST;
    parameter.needResend = NO;
    return parameter;
}

+(instancetype)putRequest{
    RequestParameter *parameter = [[self alloc] init];
    parameter.header = @{HEADER_CONTENT_TYPE:HEADER_SINGER};
    parameter.httpMethod = METHOD_PUT;
    parameter.needResend = NO;
    return parameter;
}

+(instancetype)deleteRequest{
    RequestParameter *parameter = [[self alloc] init];
    parameter.header = @{HEADER_CONTENT_TYPE:HEADER_SINGER};
    parameter.httpMethod = METHOD_DELETE;
    parameter.needResend = NO;
    return parameter;
}

+(instancetype)multiPartRequest{
    RequestParameter *parameter = [[self alloc] init];
    parameter.header = @{HEADER_CONTENT_TYPE:HEADER_MULTI};
    parameter.httpMethod = METHOD_POST;
    parameter.needResend = NO;
    return parameter;
}

+(instancetype)getRequest{
    RequestParameter *parameter = [[self alloc] init];
    parameter.header = @{HEADER_CONTENT_TYPE:HEADER_SINGER};
    parameter.httpMethod = METHOD_GET;
    parameter.needResend = NO;
    return parameter;
}

-(void)setUrl:(NSString *)url withParam:(NSDictionary *)dic{
    NSMutableString *mUrl = [[NSMutableString alloc] initWithString:url];
    if([[dic allKeys] count] > 0){
        [mUrl appendString:@"?"];
        for (NSString *key in [dic allKeys]) {
            [mUrl appendString:[NSString stringWithFormat:@"%@=%@&",key,[dic valueForKey:key]]];
        }
        self.url = [mUrl substringToIndex:[mUrl length] - 1];
    }
    else{
        self.url = url;
    }
}
@end
