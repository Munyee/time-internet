//
//  HwGetGatewayConfigStatusResult.h
//  HwMobileSDK
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import "HwResult.h"
#import "HwSetGatewayConfigStatusParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface HwGetGatewayConfigStatusResult : HwResult

/**
 配置状态：已完成/未完成
 */
@property (nonatomic, assign) kHwGatewayConfigStatus configStatus;

@end

NS_ASSUME_NONNULL_END
