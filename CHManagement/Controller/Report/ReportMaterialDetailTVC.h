//
//  ReportMaterialDetailTVC.h
//  CHManagement
//
//  Created by Peng, Troy on 5/9/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuditMaterialsVO.h"
#import "CheckUpdateProtocol.h"

@interface ReportMaterialDetailTVC : UITableViewController

@property (nonatomic, assign) BOOL checkable;

@property (nonatomic, strong) AuditMaterialsVO* auditMaterialsVO;

@property (nonatomic, weak) id<CheckUpdateProtocol> delegate;

@end
