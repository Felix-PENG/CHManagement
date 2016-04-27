//
//  NetworkFile.h
//  CHManagement
//
//  Created by Peng, Troy on 4/27/16.
//  Copyright © 2016 楚淮集团. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#define MIME_JPG @"image/jpeg"
#define MIME_ZIP @"application/zip"

@interface NetworkFile : JSONModel

@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,copy) NSString *mineType;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
