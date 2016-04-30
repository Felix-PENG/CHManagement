//
//  LoadMoreCell.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/30.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

enum LoadStatus {
    ClickToLoad,
    NoMore,
    Loading
};

@interface LoadMoreCell : UITableViewCell

@property (nonatomic, assign) NSUInteger status;

@end
