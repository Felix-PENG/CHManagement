//
//  RoleCell.h
//  CHManagement
//
//  Created by Peng, Troy on 5/12/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *roleNameField;

- (void)configureCell:(NSString*)roleName;

@end
