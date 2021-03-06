//
//  ReportRejectedCell.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/5.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "ReportRejectedCell.h"

#define REPORT_REJECTED_CELL_TAG_OFFSET 100

@interface ReportRejectedCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rejectReasonLabel;
@end

@implementation ReportRejectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOffsetTag:(NSUInteger)tag
{
    self.tag = REPORT_REJECTED_CELL_TAG_OFFSET + tag;
}

- (IBAction)modifyButtonPressed:(id)sender
{
    [self.delegate modifyButtonPressed:self.tag - REPORT_REJECTED_CELL_TAG_OFFSET];
}

- (void)configureCellWithTitle:(NSString*)title withTime:(NSInteger)time withUsername:(NSString*)userName withRole:(NSString*)role withDetail:(NSString*)detail withPrice:(double)price withReason:(NSString *)reason{
    _titleLabel.text = title;
    _userNameLabel.text = userName;
    _roleLabel.text = role;
    _detailLabel.text = detail;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",price];
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _dateTimeLabel.text = [formatter stringFromDate:date];
    
    _rejectReasonLabel.text = reason;
    
}

@end
