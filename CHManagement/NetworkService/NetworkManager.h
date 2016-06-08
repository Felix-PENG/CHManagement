//
//  NetworkManager.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestParameter.h"

@class File;

@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)httpActionWithParameter:(RequestParameter *)parameter completionHandler:(void (^) (id responseObject))handler;

#pragma mark Account api
- (void)signIn:(NSString *)email pswd:(NSString *)pswd completionHandler:(void (^)(NSDictionary *))handler;

- (void)signUpWithEmail:(NSString*)email withPswd:(NSString*)pswd withName:(NSString*)name withCompanyCode:(NSString*)company_code completionHandler:(void (^)(NSDictionary *))handler;

- (void)registerWithEmail:(NSString*)email withPswd:(NSString*)pswd withName:(NSString*)name withRoleId:(NSInteger)role_id withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changePswd:(NSString*)pswd withNewPswd:(NSString*)n_pswd withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark Group api
- (void)getAdminGroupIdWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)createGroupWithName:(NSString*)name completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeGroupName:(NSString*)name withGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getAllGroupsWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)getGroupWithGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteGroupWithGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getGroupsByUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark Role api
- (void)createRoleAndPermissionWithName:(NSString*)name withPermissionList:(NSString*)permission_list completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteRoleWithRoleId:(NSInteger)role_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeRoleWithRoleId:(NSInteger)role_id withName:(NSString*)name completionHandler:(void (^)(NSDictionary *))handler;

- (void)getRolesWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)getRolesWithRoleId:(NSInteger)role_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getRolePermissionWithRoleId:(NSInteger)role_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeRolePermissionWithRoleId:(NSInteger)role_id withPermissionList:(NSString*)permission_list completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark Permission api
- (void)getPermissionsWithCompletionHandler:(void (^)(NSDictionary *))handler;

#pragma mark User api
- (void)getUsersWithCompletionHandler:(void (^)(NSDictionary *))handler;

- (void)getUserById:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteUserById:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeUserWithName:(NSString*)name withRoleId:(NSInteger)role_id withGroupId:(NSInteger)group_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark Sign api
- (void)signByUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getSignStatusByUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark File api
- (void)createFileWithName:(NSString*)name withSize:(NSString*)size withUrl:(NSString*)url withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getUploadTokenWithName:(NSString*)name withKeyPre:(NSString*)key_pre completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteFileWithFileId:(NSInteger)file_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getFilesWithPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler;

- (void)downloadFile:(File *)file success:(void (^)(id))success failure:(void (^)(NSError *))failure progress:(void (^)(float))progress;

#pragma mark Message api
- (void)createMessageWithIdList:(NSString*)id_list withContent:(NSString*)content withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteMessageWithMessageId:(NSInteger)message_id withInOff:(NSInteger)in_off withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getMessagesWithPage:(NSInteger)page withInOff:(NSInteger)in_off withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark Activity api
- (void)createActivityWithGroupId:(NSInteger)group_id withContent:(NSString*)content withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getActivitiesByGroupId:(NSInteger)group_id withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeActivityWithActivityId:(NSInteger)activity_id withContent:(NSString*)content withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getActivityById:(NSInteger)activity_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getYesterdayActivityWithGroupId:(NSInteger)group_id withActivityId:(NSInteger)activity_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getYesterdayActivityByGroupId:(NSInteger)group_id completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark Schedule api
- (void)createScheduleWithYesterday:(NSString*)yst withToday:(NSString*)tdy withTomorrow:(NSString*)tmw withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeScheduleWithId:(NSInteger)schedule_id withYesterday:(NSString*)yst withToday:(NSString*)tdy withTomorrow:(NSString*)tmw completionHandler:(void (^)(NSDictionary *))handler;

- (void)getSchedulesWithPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getScheduleById:(NSInteger)schedule_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getYesterdayScheduleByUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getYesterdayScheduleById:(NSInteger)schedule_id completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark AuditMaterials api
- (void)createAuditMaterialsWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withType:(NSString*)type withUnitPrice:(double)unit_price withNum:(NSInteger)num withIn_off:(NSInteger)in_off withDealerName:(NSString*)dealer_name withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeAuditMaterialsWithId:(NSInteger)auditMaterials_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name  withType:(NSString*)type withUnitPrice:(double)unit_price withNum:(NSInteger)num withIn_off:(NSInteger)in_off withDealerName:(NSString*)dealer_name withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteAuditMaterialsWithId:(NSInteger)auditMaterials_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getAuditMaterialsListWithStatus:(NSInteger)audit_status withIn_off:(NSInteger)in_off withPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getAuditMaterialsListWithGroupId:(NSInteger)group_id withStatus:(NSInteger)audit_status withIn_off:(NSInteger)in_off withPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getAuditMaterialsById:(NSInteger)auditMaterials_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)auditAuditMaterialsWithId:(NSInteger)auditMaterials_id withStatus:(NSInteger)audit_status withReason:(NSString*)reason completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark AuditOthers api
- (void)createAuditOthersWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withUnitPrice:(double)unit_price withNum:(NSInteger)num withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeAuditOthersWithId:(NSInteger)auditOthers_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withUnitPrice:(double)unit_price withNum:(NSInteger)num withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteAuditOthersWithId:(NSInteger)auditOthers_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getAuditOthersListWithStatus:(NSInteger)audit_status withPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getAuditOthersListWithGroupId:(NSInteger)group_id withStatus:(NSInteger)audit_status withPage:(NSInteger)page withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getAuditOthersById:(NSInteger)auditOthers_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)auditAuditOthersWithId:(NSInteger)auditOthers_id withStatus:(NSInteger)audit_status withReason:(NSString*)reason completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark Bill api
- (void)createBillWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withIn_off:(NSInteger)in_off withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeBillWithId:(NSInteger)bill_id withContent:(NSString*)content withMoney:(double)money withIn_off:(NSInteger)in_off withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getBillById:(NSInteger)bill_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getBillsWithGroupId:(NSInteger)group_id withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark BillBuilding api
- (void)createBillBuildingWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withPurName:(NSString*)purchaser_name withPurPhone:(NSString*)purchaser_phone withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeBillBuildingWithId:(NSInteger)billBuilding_id withContent:(NSString*)content withMoney:(double)money withPurName:(NSString*)purchaser_name withPurPhone:(NSString*)purchaser_phone withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getBillBuildingById:(NSInteger)billBuilding_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getBillBuildingsWithGroupId:(NSInteger)group_id withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark BillMaterials api
- (void)createBillMaterialsWithGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withType:(NSString*)type withUnitPrice:(double)unit_price withNum:(NSInteger)num withIn_off:(NSInteger)in_off withDealerName:(NSString*)dealer_name withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)changeBillMaterialsWithId:(NSInteger)billMaterials_id withGroupId:(NSInteger)group_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withType:(NSString*)type withUnitPrice:(double)unit_price withNum:(NSInteger)num withIn_off:(NSInteger)in_off withDealerName:(NSString*)dealer_name withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteBillMaterialsWithId:(NSInteger)billMaterials_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getBillMaterialsListWithGroupId:(NSInteger)group_id withStatus:(NSInteger)finish_status withIn_off:(NSInteger)in_off withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler;

- (void)getBillMaterialsById:(NSInteger)billMaterials_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)finishBillMaterialsWithId:(NSInteger)billMaterials_id withStatus:(NSInteger)finish_status withUrl:(NSString*)url completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark BillOthers api
- (void)changeBillOthersWithId:(NSInteger)billOthers_id withContent:(NSString*)content withMoney:(double)money withName:(NSString*)name withUnitPrice:(double)unit_price withNum:(NSInteger)num withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteBillOthersWithId:(NSInteger)billOthers_id withUserId:(NSInteger)user_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)getBillOthersListByStatus:(NSInteger)finish_status completionHandler:(void (^)(NSDictionary *))handler;

- (void)getBillOthersListWithGroupId:(NSInteger)group_id withStatus:(NSInteger)finish_status withPage:(NSInteger)page completionHandler:(void (^)(NSDictionary *))handler;

- (void)getBillOthersById:(NSInteger)billOthers_id completionHandler:(void (^)(NSDictionary *))handler;

- (void)finishBillOthersWithId:(NSInteger)billOthers_id withStatus:(NSInteger)finish_status withUrl:(NSString*)url completionHandler:(void (^)(NSDictionary *))handler;

#pragma mark - Push norification

- (void)setDeviceToken:(NSUInteger)userId token:(NSString *)token completionHandler:(void (^)(NSDictionary *))handler;

- (void)deleteDeviceToken:(NSUInteger)userId completionHandler:(void (^)(NSDictionary *))handler;

@end
