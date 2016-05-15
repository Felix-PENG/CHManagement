//
//  AddActivityTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/30.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ModalTableViewController.h"
#import "ActivityVO.h"

@protocol AddActivityProtocol <NSObject>

- (void)needRefresh;

@end

@interface AddActivityTVC : ModalTableViewController

@property (nonatomic, strong) ActivityVO *activity;

@property (nonatomic, weak) id<AddActivityProtocol> delegate;

@end
