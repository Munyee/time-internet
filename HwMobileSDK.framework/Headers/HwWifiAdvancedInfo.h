#import <Foundation/Foundation.h>
#import "HwCommonDefine.h"

/**
 频宽 (Frequency bandwidth)
 */
typedef enum
{
    kHwFrequencyWidthM20 = 0,
    kHwFrequencyWidthM40,
    kHwFrequencyWidthAUTOM20M40,
    kHwFrequencyWidthAUTOM20M40M80,
    kHwFrequencyWidthM160,
    kHwFrequencyWidthUnknow = 999
}HwFrequencyWidth;

/**
 *  
 *
 *  @brief WIFI高级参数信息 (advanced Wi-Fi parameter information)
 *
 *  @since 1.6.0
 */
@interface HwWifiAdvancedInfo : NSObject

/** WIFI 频段 ，2.4G和5G (Wi-Fi band, 2.4G or 5G)*/
@property (nonatomic) HwRadioType redioType;

/** 频宽 (Frequency bandwidth)*/
@property (nonatomic) HwFrequencyWidth frequencyWidth;


@end
