//
//  hwS3StorageSpaceData.h
//  FunctionSDK
//  云存储盘符对象

//  Copyright © 2016 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hwS3StorageSpaceData : NSObject

/** 剩余可用大小 kb*/
@property (nonatomic,strong) NSNumber * discFreeSize;

/** 总共可用空间 kb*/
@property (nonatomic,strong) NSNumber * discTotalSize;

/** 存储已用空间 kb*/
@property (nonatomic,strong) NSNumber * discUsedSize;
@end
