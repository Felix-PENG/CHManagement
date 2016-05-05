//
//  Constants.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (NSDictionary *)kPermissionDictionary
{
    return @{@"上报" : @[@(FundsReport), @(BuildingMaterialPurchaseReport)],
             @"登记" : @[@(FundsRegister), @(BuildingMaterialPurchaseRegister), @(BuildingMaterialSellRegister), @(SaleBuildingRegister), @(FundsMovementRegister)],
             @"审核" : @[@(FundsCheck), @(BuildingMaterialPurchaseCheck)],
             @"管理" : @[@(ApartmentManagement), @(RoleManagement), @(UserManagement)]};
}

@end
