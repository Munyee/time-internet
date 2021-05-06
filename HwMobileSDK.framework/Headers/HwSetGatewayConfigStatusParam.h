//
//  HwSetGatewayConfigStatusParam.h
//  HwMobileSDK
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    kHwGatewayConfigStatusPending,  //未完成
    kHwGatewayConfigStatusDone,     //已完成
} kHwGatewayConfigStatus;

@interface HwSetGatewayConfigStatusParam : NSObject

/**
 配置状态：已完成/未完成
 */
@property (nonatomic, assign) kHwGatewayConfigStatus configStatus;

@end

NS_ASSUME_NONNULL_END
