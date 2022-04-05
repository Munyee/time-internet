//
//  HwSetWlanHardwareSwitchParam.h
//  HwMobileSDK
//
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 频段类型
 
 - HwSetWlanRadioTypeG2P4: 2.4G
 - HwSetWlanRadioTypeG5: 5G
 */
typedef NS_ENUM(NSInteger , HwSetWlanRadioType) {
    HwSetWlanRadioTypeG2P4,
    HwSetWlanRadioTypeG5,
};

@interface HwSetWlanHardwareSwitchParam : NSObject

//频段类型， "G2P4"代表2.4G，"G5"代表5G
@property (nonatomic , assign) HwSetWlanRadioType radioType;

/** 设备MAC地址，为空或者不指定代表网关本身，不为空代表下挂AP */
@property(nonatomic, copy) NSString *mac;

/** 频段启用状态。true：开启。false：关闭 */
@property (nonatomic, assign) BOOL enable;

@end

NS_ASSUME_NONNULL_END
