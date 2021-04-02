#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief LED信息 (LED information)
 *
 *  @since 1.6.0
 */
@interface HwLedInfo : NSObject

typedef NS_ENUM(NSInteger, HwLedStatus) {
    kHwLedStatusON,
    kHwLedStatusOFF
};

/** LED状态 (LED status)*/
@property (nonatomic ,assign) HwLedStatus ledStatus;

@end
