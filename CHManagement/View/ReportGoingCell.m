//
//  ReportGoingCell.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportGoingCell.h"

@interface ReportGoingCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;

@end

@implementation ReportGoingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithTitle:(NSString*)title withTime:(NSInteger)time withUsername:(NSString*)userName withRole:(NSString*)role withDetail:(NSString*)detail withPrice:(double)price
{
    _titleLabel.text = title;
    _userNameLabel.text = userName;
    _roleLabel.text = role;
    _detailLabel.text = detail;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",price];
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _dateTimeLabel.text = [formatter stringFromDate:date];

    NSInteger expireHours = -[date timeIntervalSinceNow]/3600;
    _expireLabel.text = [NSString stringWithFormat:@"超出%@小时",[NSNumber numberWithInteger:expireHours]];
}

@end
