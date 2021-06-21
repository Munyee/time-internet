#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 网关流量(gateway traffic)
 *
 *  @since 1.0
 */
@interface HwGatewayTraffic : NSObject 
    
/** 表示上行流量, KBytes (Uplink traffic in KB)*/
@property(nonatomic) long usTraffic;

/** 表示下行流量, KBytes (Downlink traffic in KB)*/
@property(nonatomic) long dsTraffic;

/** 上行实时速率；无值返回-1，KBytes*/
@property(nonatomic) int upSpeed;

/** 下行实时速率；无值返回-1, KBytes*/
@property(nonatomic) int downSpeed;
	
@end
