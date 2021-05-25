//
//  HwCameraCloudStorageObjectsRequest.h
//  FunctionSDK
//

//  Copyright © 2016年 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwCameraCloudStorageObjectsRequest : NSObject

@property int pageNum;
@property int pageSize;
@property (nonatomic,copy) NSString * cameraSN;
@end
