//
//  File.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/10.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "File.h"
#import "FileVO.h"

@implementation File

- (instancetype)initWithFileVO:(FileVO *)fileVO
{
    self = [super init];
    if (self) {
        self.fileVO = fileVO;
    }
    return self;
}

- (void)delete
{
    [[NSFileManager defaultManager] removeItemAtPath:self.localURL.absoluteString error:nil];
}

- (NSURL *)localURL
{
    if (self.fileVO) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *directory = [NSString stringWithFormat:@"%@/Downloads", path];
        [File createFileDirectory:directory];
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", directory, self.fileVO.name]];
    } else {
        return nil;
    }
}

- (BOOL)existed
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.localURL.absoluteString];
}

+ (void)createFileDirectory:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        NSLog(@"Created: %@", path);
    }
}

+ (NSString *)dataTimeImageName
{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *timeStr = [formatter stringFromDate:currDate];
    
    return [NSString stringWithFormat:@"IMG_%@.JPG", timeStr];
}

@end
