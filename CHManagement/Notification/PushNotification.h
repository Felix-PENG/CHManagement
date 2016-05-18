//
//  PushNotification.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/18.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AppleMessage.h"

enum NotificationType {
    NotificationTypeUnknown,
    NotificationTypeMessage,
    NotificationTypeOthers,
    NotificationTypeMaterials,
    NotificationTypeCheckOthers,
    NotificationTypeCheckMaterials
};

@interface PushNotification : JSONModel
@property (nonatomic, strong) AppleMessage *aps;
@property (nonatomic, assign) NSInteger code;
@end
