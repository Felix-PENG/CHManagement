//
//  MailCell.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailCell : UITableViewCell

- (void)configureInboxCellWithContent:(NSString*)content withSender:(NSString*)sender withTime:(NSInteger)time;

- (void)configureOutboxCellWithContent:(NSString*)content withReceivers:(NSArray*)receivers withTime:(NSInteger)time;

@end
