//
//  HwS3StorageListRequest.h
//  FunctionSDK
//  查询文件列表请求对象

//  Copyright © 2016 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwCloudStoreTypeEnums.h"

@interface HwS3StorageListRequest : NSObject

/** 家庭云还是应用云*/
@property APP_STORAGE_TYPE  availableCloudType;

/** 云存储路径：Camer/SN_XXXXXX*/
@property(nonatomic,copy) NSString *url;
@end
