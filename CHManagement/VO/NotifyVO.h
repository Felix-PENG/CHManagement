//
//  NotifyVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface NotifyVO : JSONModel

@property (nonatomic,assign) NSInteger message_notify;//你有新消息了
@property (nonatomic,assign) NSInteger others_notify;//你的经费单被审核
@property (nonatomic,assign) NSInteger materials_notify;//你的建材买入单被审核
@property (nonatomic,assign) NSInteger audit_others_notify;//有经费单待审核。。。管理员功能
@property (nonatomic,assign) NSInteger audit_materials_notify;//有建材买入单待审核。。。管理员功能

@end
