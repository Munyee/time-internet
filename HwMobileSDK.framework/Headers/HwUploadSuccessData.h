//
//  HwUploadSuccessData.h
//  MobileSDK
//
//  Created by xieshimin on 20/06/2017.
//  Copyright © 2017 com.huawei. All rights reserved.
//

typedef NS_ENUM(NSInteger, HwStorageType) {
    HwStorageTypeCloud,
    HwStorageTypeOnt
};

#import <Foundation/Foundation.h>

@interface HwUploadSuccessData : NSObject

/** 文件名称 */
@property (nonatomic, copy) NSString *fileName;

/** 文件路径 */
@property (nonatomic, copy) NSString *fileDirection;

/** 存储类型 */
@property (nonatomic, assign) HwStorageType storageType;

@end
