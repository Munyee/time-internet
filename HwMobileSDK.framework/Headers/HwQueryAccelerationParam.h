//
//  HwQueryAccelerationParam.h
//  HwMobileSDK
//
//  Created by ios on 2021/5/14.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwQueryAccelerationParam : NSObject

/// 开始时间(秒)
@property (nonatomic, assign) NSTimeInterval startTime;

/// 结束时间(秒)
@property (nonatomic, assign) NSTimeInterval endTime;

@end

@interface HwQueryUserAccelerationParam : HwQueryAccelerationParam

/// sta的mac
@property (nonatomic, copy) NSString *userId;

/// 加速类型：GAME、EDUCATION、OFFICE
@property (nonatomic, copy) NSString *appType;

@end

NS_ASSUME_NONNULL_END
