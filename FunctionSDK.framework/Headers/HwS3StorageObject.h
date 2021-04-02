//
//  HwS3StorageObject.h
//  FunctionSDK
//  云存储对象

//  Copyright © 2016 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwS3StorageObject : NSObject

/** 云存储对象名称*/
@property(nonatomic,copy) NSString *name;

/** 云存储对完整路径*/
@property(nonatomic,copy) NSString *url;

/** 云存储对象是否为文件夹*/
@property BOOL isFolder;
@end
