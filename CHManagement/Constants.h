//
//  Constants.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_PRE_PICTURE @"picture"
#define KEY_PRE_FILE @"file"

#define STATUS_NOT_FINISHED 0
#define STATUS_FINISHED 1

#define BILL_IN 0
#define BILL_OFF 1

enum PermissionID{
    Unknown,
    FundsReport,
    BuildingMaterialPurchaseReport,
    FundsRegister,
    BuildingMaterialPurchaseRegister,
    BuildingMaterialSellRegister,
    SaleBuildingRegister,
    FundsMovementRegister,
    FundsCheck,
    BuildingMaterialPurchaseCheck,
    ApartmentManagement,
    RoleManagement,
    UserManagement
};

@interface Constants : NSObject

+ (NSDictionary *)kPermissionDictionary;

@end
