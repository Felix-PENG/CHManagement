//
//  RoleCell.m
//  CHManagement
//
//  Created by Peng, Troy on 5/12/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "RoleCell.h"

@implementation RoleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configureCell:(NSString*)roleName{
    self.roleNameField.text = roleName;
}

@end
