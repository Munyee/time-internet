
#import "HwResult.h"

/**
 *  
 *
 *  @brief 查询WIFI状态操作结果(Wi-Fi status query result)
 *
 *  @since 1.0
 */
@interface HwGetWifiStatusResult : HwResult

/** WIFI使能状态 (Wi-Fi enable status)*/
@property(nonatomic) BOOL wifiStatus;

@end
