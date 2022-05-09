#import <Foundation/Foundation.h>

/**

 *
 *  @brief 网关在线时长 (gateway online duration)
 */
@interface HwGatewayTimeDurationInfo : NSObject

/** 系统上电时间，单位：秒 (System power-on duration, in seconds)*/
@property (nonatomic ,assign) int sysDuration;

/** pppoe拨号成功持续时间，单位：秒 (PPPoE dialing success duration, in seconds)*/
@property (nonatomic ,assign) int pppoEDuration;

/** pon注册授权成功持续时间，单位：秒(从pon线路的逻辑ID认证成功开始计时)(PON registration authentication success duration, in seconds, counting from an authentication success of the PON link logical ID)*/
@property (nonatomic ,assign) int ponDuration;

@end
