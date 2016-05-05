//
//  SendMailTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "SendMailTVC.h"

@interface SendMailTVC ()
@property (weak,nonatomic) IBOutlet UIButton* receiversButton;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation SendMailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[self.view tintColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated{
    if([self.receivers count] > 0){
        //self.receiversButton.titleLabel.text = @"111";
    }
}

- (IBAction)cancelButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendButtonPressed:(id)sender {
}

@end
