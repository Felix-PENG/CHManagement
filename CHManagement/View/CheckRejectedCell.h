//
//  CheckRejectedCell.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckRejectedCell : UITableViewCell

- (void)configureCellWithTitle:(NSString*)title withTime:(NSInteger)time withUsername:(NSString*)userName withRole:(NSString*)role withDetail:(NSString*)detail withPrice:(double)price withReason:(NSString*)reason;

@end
