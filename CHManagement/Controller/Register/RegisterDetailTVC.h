//
//  RegisterDetailTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ImagePickPreviewTVC.h"
#import "BillOthersVO.h"

@interface RegisterDetailTVC : ImagePickPreviewTVC

@property (nonatomic, assign) BOOL uploadable;
@property (nonatomic, strong) BillOthersVO *bill;

@end
