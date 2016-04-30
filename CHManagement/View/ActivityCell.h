//
//  ActivityCell.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/29.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

- (void)configureWithContent:(NSString *)content time:(NSUInteger)time;

@end
