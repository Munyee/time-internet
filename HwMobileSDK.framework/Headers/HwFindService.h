#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwGatewayDevice.h>

@protocol HwCallback;

/**
 *  
 *
 *  @brief 设备发现服务
 *
 *  @since 1.0
 */
@interface HwFindService : NSObject

/**
 *  
 *
 *  @brief 查找设备
 *
 *  @param conditions 查找的条件(SN,MAC,PPPOE_ACCOUNT,COMMON)
 *  @param callback   返回回调
 *
 *  @since 1.0
 */
- (void)find:(NSDictionary *)conditions withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 更新网关sn
 *
 *  @param gatewayDevice 网关信息
 *  @param newSn 网关新sn
 *  @param callback   返回回调 HwResult
 *
 */
- (void)replaceGatewaySn:(HwGatewayDevice *)gatewayDevice sn:(NSString *)newSn withCallback:(id<HwCallback>)callback;

@end
