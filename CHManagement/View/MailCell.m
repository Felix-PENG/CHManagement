//
//  MailCell.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "MailCell.h"
#import "UserShortVO.h"

@interface MailCell()
@property IBOutlet UILabel* timeLabel;
@property IBOutlet UILabel* senderHintLabel;
@property IBOutlet UILabel* senderLabel;
@property IBOutlet UILabel* contentLabel;
@end

@implementation MailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureInboxCellWithContent:(NSString*)content withSender:(NSString*)sender withTime:(NSInteger)time{
    self.contentLabel.text = content;
    self.senderLabel.text = sender;
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [formatter stringFromDate:date];
}

- (void)configureOutboxCellWithContent:(NSString*)content withReceivers:(NSArray*)receivers withTime:(NSInteger)time{
    self.contentLabel.text = content;
    
    self.senderHintLabel.text = @"收件人";
    NSString* receiversString = [[NSString alloc]init];
    for(UserShortVO* user in receivers){
        receiversString = [receiversString stringByAppendingFormat:@"%@; ",[user name]];
    }
    self.senderLabel.text = receiversString;
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [formatter stringFromDate:date];
}

@end
