#import <Foundation/Foundation.h>
#import "HwResult.h"

/**
 *  
 *
 *  @brief 查询下挂设备加速状态操作结果(query the operation result of speeding up a connected device)
 *
 *  @since 1.0
 */
@interface HwGetLanDeviceSpeedStateResult : HwResult

/** 是否加速状态 (Speed-up or not)*/
@property(nonatomic) BOOL isSpeedUp;

@end
