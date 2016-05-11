//
//  RegisterCell.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterCell.h"

@interface RegisterCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation RegisterCell

- (void)setTitle:(NSString *)title dateTime:(NSUInteger)dateTime group:(NSString *)group user:(NSString *)user detail:(NSString *)detail money:(double)money
{
    self.titleLabel.text = title;
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:dateTime/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.dateTimeLabel.text = [formatter stringFromDate:date];
    
    self.userNameLabel.text = user;
    
    self.roleLabel.text = group;
    
    self.detailLabel.text = detail;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.1f", money];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
