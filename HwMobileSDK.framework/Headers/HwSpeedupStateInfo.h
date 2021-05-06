#import <Foundation/Foundation.h>

/**
 加速状态(Speed-up status)
 */
typedef enum
{
    kHwSpeedStateOn = 1,
    kHwSpeedStateOff
} HwSpeedState;

/**
 *  
 *
 *  @brief 加速状态信息(speed-up status information)
 *
 *  @since 1.0
 */
@interface HwSpeedupStateInfo : NSObject

/** 加速状态 (Speed-up status)*/
@property (nonatomic) HwSpeedState speedState;

@end
