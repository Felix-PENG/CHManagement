//
//  ReportRejectedCell.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReportRejectedDelegate <NSObject>

- (void)modifyButtonPressed:(NSUInteger)index;

@end

@interface ReportRejectedCell : UITableViewCell

@property (nonatomic, weak) id<ReportRejectedDelegate> delegate;

- (void)setOffsetTag:(NSUInteger)tag;

@end
