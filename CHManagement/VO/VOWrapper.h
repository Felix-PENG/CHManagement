//
//  VOWrapper.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultVO.h"
#import "JSONModel.h"

@interface VOWrapper : JSONModel

@property (nonatomic,strong) ResultVO* resultVO;
@property (nonatomic,strong) NSObject* o;

@end
