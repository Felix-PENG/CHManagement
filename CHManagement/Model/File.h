//
//  File.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/10.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileVO;

@interface File : NSObject

@property (nonatomic, readonly) NSURL *localURL;
@property (nonatomic, readonly) BOOL existed;
@property (nonatomic, strong) FileVO *fileVO;

- (instancetype)initWithFileVO:(FileVO *)fileVO;

- (void)delete;

@end
