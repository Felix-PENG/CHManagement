//
//  AddSellBuildingTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/6.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "AddSellBuildingTVC.h"

@interface AddSellBuildingTVC ()
@property (weak, nonatomic) IBOutlet UITextField *buildingLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *buyerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *buyerPhoneNumberTextField;

@end

@implementation AddSellBuildingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)doneButtonPressed:(id)sender {
}

@end