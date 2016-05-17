//
//  LoadMoreCell.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/4/30.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "LoadMoreCell.h"

@interface LoadMoreCell()
@property (weak, nonatomic) IBOutlet UILabel *loadMoreLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation LoadMoreCell

- (void)setStatus:(NSUInteger)status
{
    switch (status) {
        case ClickToLoad:
            self.loadMoreLabel.text = @"点击加载更多";
            self.loadMoreLabel.textColor = [self.contentView tintColor];
            self.loadMoreLabel.hidden = NO;
            self.indicator.hidden = YES;
            self.userInteractionEnabled = YES;
            break;
        case Loading:
            self.loadMoreLabel.hidden = YES;
            self.indicator.hidden = NO;
            self.userInteractionEnabled = NO;
            [self.indicator startAnimating];
            break;
        default: // NoMore
            self.loadMoreLabel.text = @"没有更多";
            self.loadMoreLabel.textColor = [UIColor lightGrayColor];
            self.loadMoreLabel.hidden = NO;
            self.indicator.hidden = YES;
            self.userInteractionEnabled = NO;
            break;
    }
    
    _status = status;
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
