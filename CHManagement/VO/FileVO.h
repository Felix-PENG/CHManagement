//
//  FileVO.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface FileVO : JSONModel

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* size;
@property (nonatomic,copy) NSString* url;
@property (nonatomic,copy) NSString* uploader_name;

@end
