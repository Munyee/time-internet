#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwResult.h>

/**
 *  
 *
 *  @brief 更换网关操作结果
 *
 *  @since 1.7
 */
@interface HwReplaceGatewayResult : HwResult

/** 新网关设备ID (New Gateway ID)*/
@property(nonatomic, copy) NSString *deviceId;

@end
