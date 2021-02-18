//
//  HwWlanHardwareSwitchInfo.h
//  HwMobileSDK
//
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 频段类型
 
 - HwWlanInfoRadioTypeG2P4: 2.4G
 - HwWlanInfoRadioTypeG5: 5G
 - HwWlanInfoRadioTypeAll: 所有频段
 */
typedef NS_ENUM(NSInteger , HwWlanInfoRadioType) {
    HwWlanInfoRadioTypeG2P4,
    HwWlanInfoRadioTypeG5,
    HwWlanInfoRadioTypeAll,
};

@interface HwWlanHardwareSwitchInfo : NSObject

/** 频段类型,"G2P4"代表2.4G，"G5"代表5G，"ALL"代表所有频段*/
@property (nonatomic, assign) HwWlanInfoRadioType radioType;

/** 此频段是否开启，取值：FALSE：关闭，TRUE：开启 */
@property(nonatomic,assign) BOOL enable;

@end

NS_ASSUME_NONNULL_END
