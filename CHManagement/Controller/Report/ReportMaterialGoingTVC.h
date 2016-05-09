//
//  ReportMaterialGoingTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportGoingTVC.h"

@interface ReportMaterialGoingTVC : ReportGoingTVC

@property (nonatomic, assign) NSNumber* choosedGroupId;

- (void)refresh;

@end
