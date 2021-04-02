//
//  HwS3StorageUploadRequest.h
//  FunctionSDK
//  上传文件请求对象

//  Copyright © 2016 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwCloudStoreTypeEnums.h"

@interface HwS3StorageUploadRequest : NSObject

/** 家庭云还是应用云*/
@property APP_STORAGE_TYPE  availableCloudType;

/** 需要上传的文件所在的本地目录*/
@property(nonatomic,copy) NSString *fileLocalPath;

/** 云存储路径：Camer/SN_XXXXXX*/
@property(nonatomic,copy) NSString *url;
@end
