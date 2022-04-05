#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 下挂设备流量信息(traffic of a connected device)
 *
 *  @since 1.0
 */
@interface HwLanDeviceTraffic : NSObject

/** 发送流量(KBytes) (Transmit traffic (KB))*/
@property(nonatomic) long sendKBytes;

/** 接收流量(KBytes) (Receive traffic (KB))*/
@property(nonatomic) long recvKBytes;

/** 上行速率 */
@property(nonatomic, assign) long upSpeed;

/** 下行速率 */
@property(nonatomic, assign) long downSpeed;

@end
