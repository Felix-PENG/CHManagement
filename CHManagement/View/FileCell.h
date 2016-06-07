//
//  FileCell.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell

@property (nonatomic, assign, readonly) BOOL open;
@property (nonatomic, strong) void (^reportBlock)();
@property (nonatomic, strong) void (^deleteBlock)();
@property (nonatomic, strong) void (^swipeBlock)();

- (void)setSize:(NSString *)size dateTime:(NSUInteger)dateTime uploader:(NSString *)uploaderName file:(NSString *)fileName;

- (void)setDownloaded:(BOOL)downloaded;

- (void)closeMenu;

@end
