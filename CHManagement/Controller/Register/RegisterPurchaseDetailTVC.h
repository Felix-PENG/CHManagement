//
//  RegisterPurchaseDetailTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ImagePickPreviewTVC.h"
#import "BillMaterialsVO.h"
#import "AddRegisterProtocol.h"

@interface RegisterPurchaseDetailTVC : ImagePickPreviewTVC

@property (nonatomic, assign) BOOL uploadable;
@property (nonatomic, strong) BillMaterialsVO *bill;
@property (nonatomic, weak) id<AddRegisterProtocol> delegate;
@end
