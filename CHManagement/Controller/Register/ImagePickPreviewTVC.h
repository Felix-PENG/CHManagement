//
//  ImagePickPreviewTVC.h
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/12.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickPreviewTVC : UITableViewController

@property (nonatomic, weak) UIImageView *imageView;

- (void)pickImage;

- (void)uploadImage:(UIImage *)image;

@end
