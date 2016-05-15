//
//  AddPlanVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleVO.h"

@protocol AddPlanProtocol <NSObject>

- (void)needRefresh;

@end

@interface AddPlanVC : UIViewController

@property (nonatomic, strong) ScheduleVO* todaySchedule;

@property (nonatomic, weak)id<AddPlanProtocol> delegate;

@end
