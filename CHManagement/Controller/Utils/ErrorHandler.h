//
//  ErrorHandler.h
//  CHManagement
//
//  Created by Peng, Troy on 5/7/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ErrorHandler : NSObject

+ (UIAlertController*)showErrorAlert:(NSString*)message;

@end
