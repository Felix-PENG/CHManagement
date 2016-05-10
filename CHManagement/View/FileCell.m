//
//  FileCell.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "FileCell.h"

@interface FileCell()
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadedImageView;

@end

@implementation FileCell

- (void)setSize:(NSString *)size dateTime:(NSUInteger)dateTime uploader:(NSString *)uploaderName file:(NSString *)fileName
{
    self.sizeLabel.text = size;
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:dateTime/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.dateTimeLabel.text = [formatter stringFromDate:date];
    
    self.uploaderLabel.text = uploaderName;
    
    self.fileNameLabel.text = fileName;
    
    self.downloadedImageView.hidden = YES;
}

- (void)setDownloaded:(BOOL)downloaded
{
    self.downloadedImageView.hidden = !downloaded;
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
