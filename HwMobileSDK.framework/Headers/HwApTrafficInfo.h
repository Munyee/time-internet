
typedef enum : NSUInteger {
    kHwRadioTypeStatusEnable = 1,
    kHwRadioTypeStatusDisable,
} HwRadioTypeStatus;

#import <Foundation/Foundation.h>
#import "HwCommonDefine.h"

@interface HwApTrafficInfo : NSObject

/** 该AP支持的频段类别数,目前最多只支持2.4G和5G两种类别 (Number of frequency band types supported by the AP. Currently, 2.4G and 5G are supported.)*/
@property (nonatomic, assign) HwRadioType radioType;

/** 该频段是否是能取值:ENABLE/DISABLE (Whether this frequency band is enabled. Value: ENABLE or DISABLE. )*/
@property (nonatomic ) HwRadioTypeStatus status;

/** 该频段当前的工作信道 (Current working channel of this frequency band)*/
@property (nonatomic, copy) NSString *currentChannel;

/** 表示该频段类各信道的路况 (Indicate the conditions of various channels of this frequency band)*/
@property (nonatomic,strong) NSMutableArray *trafficInfoList;

/** 是否开启了自动选择信道 */
@property(nonatomic,assign) BOOL autoChannelEnable;


/**
 *  
 *
 *  @brief 自定义初始化方法(user-defined initialization method)
 *
 *  @param radioType  频段枚举类型(frequency band enumerated type)
 *  @param status     该频段是否使能，取值 ENABLE/DISABLE(Whether this frequency band is enabled. Value: ENABLE or DISABLE.)
 *  @param channel    当前工作的信道值(Current working channel value)
 *  @param trafficStr 该频段各信道的路况(conditions of various channels of this frequency band)
 *
 *  @return 返回自身的实例(Return own instances.)
 *
 *  @since 1.0
 */
- (instancetype)initWithRadioType:(HwRadioType )radioType
                       withStatus:(BOOL )status
               withCurrentChannel:(NSString *)channel
                      trafficInfo:(NSMutableArray *)trafficList;
@end
