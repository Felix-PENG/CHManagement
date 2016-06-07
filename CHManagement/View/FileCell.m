//
//  FileCell.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "FileCell.h"

#define ANIMATE_DURATION 0.3

@interface FileCell()
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadedImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation FileCell

- (void)setContainerView:(UIView *)containerView
{
    _containerView = containerView;
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_containerView addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [_containerView addGestureRecognizer:swipeRightRecognizer];
}

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

- (void)swipe:(UISwipeGestureRecognizer *)recognizer
{
    if (self.swipeBlock) {
        self.swipeBlock();
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self openMenu];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self closeMenu];
    }
}

- (void)openMenu
{
    if (!self.open) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            weakSelf.containerView.center = CGPointMake(weakSelf.frame.size.width / 2 - weakSelf.reportButton.frame.size.width - weakSelf.deleteButton.frame.size.width, weakSelf.frame.size.height / 2);
        } completion:^(BOOL finished) {
            if (finished) {
                _open = YES;
            }
        }];
    }
}

- (void)closeMenu
{
    if (self.open) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            weakSelf.containerView.center = CGPointMake(weakSelf.frame.size.width / 2, weakSelf.frame.size.height / 2);
        } completion:^(BOOL finished) {
            if (finished) {
                _open = NO;
            }
        }];
    }
}

- (IBAction)reportButtonPressed:(id)sender
{
    if (self.reportBlock) {
        self.reportBlock();
    }
}

- (IBAction)deleteButtonPressed:(id)sender
{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end
