#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwCommonDefine.h>


typedef enum : NSUInteger {
    kHwApChannelModeAUTO = 1,
    kHwApChannelModeATONCE,
} HwApChannelMode;

@interface HwApChannelInfo : NSObject

/** AP的MAC (MAC address of the AP)*/
@property (nonatomic, copy) NSString *apMac;

/** 频段类型，“G2P4”代表2.4G “G5“代表5G (Frequency band type. "G2P4" indicates 2.4G, and "G5" indicates 5G.)*/
@property (nonatomic, assign) HwRadioType radioType;

/** 频段的工作信道 (Working channel of the frequency band)*/
@property (nonatomic, copy) NSString *channel;

/** 自动调整模式,"AUTO"代表空闲自动调整,"ATONCE"代表强制立即调整 (Automatic adjustment mode. "Auto" indicates automatic adjustment in idle mode, and "ATONCE" indicates forcible immediate adjustment.)*/
@property (nonatomic, assign) HwApChannelMode mode;

/** 开启状态*/
@property (nonatomic, assign) BOOL isEnable;

@end

@interface HwQueryApChannelInfoParam : NSObject

/** AP的MAC (MAC address of the AP)*/
@property (nonatomic, copy) NSString *apMac;

/** 频段类型，“G2P4”代表2.4G “G5“代表5G (Frequency band type. "G2P4" indicates 2.4G, and "G5" indicates 5G.)*/
@property (nonatomic, assign) HwRadioType radioType;

@end
