//
//  ReportMaterialRegisterTVC.h
//  CHManagement
//
//  Created by Peng, Troy on 5/10/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "ModalTableViewController.h"
#import "AuditMaterialsVO.h"
#import "AddRegisterProtocol.h"

@interface ReportMaterialRegisterTVC : ModalTableViewController

@property (nonatomic, weak) AuditMaterialsVO* auditMaterialsVO;

@property (nonatomic, weak) id<AddRegisterProtocol> delegate;

@end
