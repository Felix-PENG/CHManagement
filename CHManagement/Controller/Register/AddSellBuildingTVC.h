//
//  AddSellBuildingTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillBuildingVO.h"
#import "AddRegisterProtocol.h"

@interface AddSellBuildingTVC : UITableViewController
@property (nonatomic, strong) BillBuildingVO *bill;
@property (nonatomic, weak) id<AddRegisterProtocol> delegate;
@end
