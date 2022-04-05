//
//  HwRestService.h
//  HwMobileSDK
//
//  Created by lxp on 2022/2/23.
//  Copyright © 2022 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwCallback.h>
#import <HwMobileSDK/HwRestParams.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwRestService : NSObject

/// 发送rest请求
/// @param param 参数
/// @param callback 回调
- (void)rest:(HwRestParams *)param callback:(id<HwCallback>)callback;

@end

NS_ASSUME_NONNULL_END
