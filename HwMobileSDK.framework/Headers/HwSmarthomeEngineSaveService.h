//
//  HwSmarthomeEngineSaveService.h
//  MobileSDK
//
//  Created by guozheng on 18/5/3.
//  Copyright © 2018年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwCallback.h"
#import "HwCallbackAdapter.h"
#import "HwIsNeededUpgradeResult.h"

// 轮询升级结果间隔时间
#define UPGRADE_QUERY_INTERVAL_TIME 5

// 升级查询超时次数
#define UPGRADE_PROGRESS_TIME_OUT 60

@interface HwSmarthomeEngineSaveService : NSObject
{
    HwCallbackAdapter *upgradeCallBack;
    
    NSTimer *timer;
    
    __block NSUInteger timerCount;
}

/**
 *  
 *
 *  @brief 是否需要升级(upgrade required or not)
 *
 *  @param deviceId 网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)isNeededUpgrade:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

@end
