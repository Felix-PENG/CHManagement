//
//  AboutView.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/21.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AboutView.h"

@implementation AboutView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:recognizer];
}

- (void)tapped
{
    [self dismiss];
}

- (void)showToView:(UIView *)view
{
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
