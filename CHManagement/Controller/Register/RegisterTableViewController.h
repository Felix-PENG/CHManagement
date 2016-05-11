//
//  RegisterTableViewController.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "CHTableViewController.h"

@interface RegisterTableViewController : CHTableViewController
{
@protected
    NSUInteger _page;
    NSMutableArray *_dataList;
    BOOL _noMoreData;
}
@property (nonatomic, readonly) NSString *cellIdentifier;
@property (nonatomic, readonly) NSString *loadMoreCellIdentifier;
@property (nonatomic, assign) NSInteger groupID;

@end
