//
//  ReportMaterialDetailTVC.m
//  CHManagement
//
//  Created by Peng, Troy on 5/9/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import "ReportMaterialDetailTVC.h"

@interface ReportMaterialDetailTVC()

@property (nonatomic, weak) IBOutlet UILabel* entryLabel;
@property (nonatomic, weak) IBOutlet UILabel* typeLabel;
@property (nonatomic, weak) IBOutlet UILabel* numLabel;
@property (nonatomic, weak) IBOutlet UILabel* unitPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* totalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* dealerNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* statusLabel;
@end

@implementation ReportMaterialDetailTVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([self.auditMaterialsVO isKindOfClass:[AuditMaterialsVO class]]){
        self.entryLabel.text = self.auditMaterialsVO.name;
        self.typeLabel.text = self.auditMaterialsVO.type;
        self.numLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.auditMaterialsVO.num]];
        self.unitPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.auditMaterialsVO.unit_price];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.auditMaterialsVO.money];
        self.dealerNameLabel.text = self.auditMaterialsVO.dealer_name;
        
        NSInteger status = self.auditMaterialsVO.audit_status;
        
        if(status == 0){
            self.statusLabel.text = @"未处理";
        }else if(status == 1){
            self.statusLabel.text = @"已审核";
        }else if(status == 2){
            self.statusLabel.text = @"被驳回";
        }else{
            self.statusLabel.text = @"审核通过";
        }
    }
}

@end
