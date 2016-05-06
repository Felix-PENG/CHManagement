//
//  RegisterDetailTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "RegisterDetailTVC.h"

@interface RegisterDetailTVC ()
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UILabel *singlePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachImageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@end

@implementation RegisterDetailTVC

- (void)setUploadable:(BOOL)uploadable
{
    _uploadable = uploadable;
    [self checkUploadState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkUploadState];
}

- (void)checkUploadState
{
    if (!self.uploadable) {
        self.addButton.hidden = YES;
        self.uploadButton.hidden = YES;
    }
}

- (IBAction)addButtonPressed:(id)sender {
}
- (IBAction)uploadButtonPressed:(id)sender {
}

@end
