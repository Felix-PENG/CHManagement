//
//  Constants.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>

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
