#import <Foundation/Foundation.h>
#import "HwResult.h"

/**
 *  
 *
 *  @brief 查询下挂设备数量操作结果(operation result of querying number of connected devices)
 *
 *  @since 1.0
 */
@interface HwQueryLanDeviceCountResult : HwResult

/** 下挂设备数量 (Number of connected devices) */
@property (nonatomic) int lanDeviceCount;

@end
