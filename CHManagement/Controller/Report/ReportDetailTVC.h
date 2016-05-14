//
//  ReportDetailTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuditOthersVO.h"
#import "CheckUpdateProtocol.h"

@interface ReportDetailTVC : UITableViewController

@property (nonatomic, assign) BOOL checkable;

@property (nonatomic, strong) AuditOthersVO* auditOthersVO;

@property (nonatomic, weak) id<CheckUpdateProtocol> delegate;

@end
