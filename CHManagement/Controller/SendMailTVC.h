//
//  SendMailTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MailBoxSwitchViewDelegate <NSObject>

@required
- (void)switchViewToOutBox;

@end

@interface SendMailTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray* receivers;
@property (nonatomic,weak) id<MailBoxSwitchViewDelegate> mailBoxSwitchViewDelegate;

@end
