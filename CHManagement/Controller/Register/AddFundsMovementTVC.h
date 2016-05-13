//
//  AddFundsMovementTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRegisterProtocol.h"
#import "BillVO.h"

@interface AddFundsMovementTVC : UITableViewController
@property (nonatomic, strong) BillVO *bill;
@property (nonatomic, weak) id<AddRegisterProtocol> delegate;
@end
