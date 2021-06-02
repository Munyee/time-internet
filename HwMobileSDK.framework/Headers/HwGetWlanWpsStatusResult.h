//
//  HwGetWlanWpsStatusResult.h
//  HwMobileSDK
//
//  Created by ios1 on 2020/4/20.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 wps设备状态
 
 - HwGetWlanWpsStatusTypeOFF: 关闭
 - HwGetWlanWpsStatusTypeON: 开启
 - HwGetWlanWpsStatusTypeUNKNOWN: unknown
 */
typedef NS_ENUM(NSInteger , HwGetWlanWpsStatusType) {
    HwGetWlanWpsStatusTypeOFF,
    HwGetWlanWpsStatusTypeON,
    HwGetWlanWpsStatusTypeUNKNOWN = 999,
};

NS_ASSUME_NONNULL_BEGIN

@interface HwGetWlanWpsStatusResult : NSObject

/** wps配置的状态 */
@property (nonatomic , assign) HwGetWlanWpsStatusType wpsStatus;

/** 信息 */
@property (nonatomic , copy) NSString *devInfo;

@end

NS_ASSUME_NONNULL_END
