//
//  SendMailTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ModalTableViewController.h"

@protocol MailBoxSwitchViewDelegate <NSObject>

@required
- (void)switchViewToOutBox;

@end

@interface SendMailTVC : ModalTableViewController

@property (nonatomic, strong) NSMutableArray* receivers;
@property (nonatomic,weak) id<MailBoxSwitchViewDelegate> mailBoxSwitchViewDelegate;

@end
