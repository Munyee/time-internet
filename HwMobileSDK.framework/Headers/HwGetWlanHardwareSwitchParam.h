//
//  HwGetWlanHardwareSwitchParam.h
//  MobileSDK_Maintain_Save
//
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 频段类型
 
 - HwGetWlanRadioTypeG2P4: 2.4G
 - HwGetWlanRadioTypeG5: 5G
 - HwGetWlanRadioTypeAll: 所有频段
 */
typedef NS_ENUM(NSInteger , HwGetWlanRadioType) {
    HwGetWlanRadioTypeG2P4,
    HwGetWlanRadioTypeG5,
    HwGetWlanRadioTypeAll,
};

@interface HwGetWlanHardwareSwitchParam : NSObject

/** 频段类型,"G2P4"代表2.4G，"G5"代表5G，"ALL"代表所有频段*/
@property (nonatomic , assign) HwGetWlanRadioType radioType;

/** 设备MAC地址，为空或者不指定代表网关本身，不为空代表下挂AP */
@property(nonatomic, copy) NSString *mac;

@end

NS_ASSUME_NONNULL_END
