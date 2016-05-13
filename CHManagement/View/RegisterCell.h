//
//  RegisterCell.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterCell : UITableViewCell

- (void)setTitle:(NSString *)title dateTime:(NSUInteger)dateTime group:(NSString *)group user:(NSString *)user detail:(NSString *)detail money:(double)money;

@end
