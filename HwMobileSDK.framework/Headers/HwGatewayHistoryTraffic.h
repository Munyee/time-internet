#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 网关历史流量节点信息 (gateway historical traffic node information)
 *
 *  @since 1.6.0
 */
@interface HwGatewayHistoryTraffic : NSObject

/** 表示该点的上行流量,单位K字节 (Uplink traffic of this node, in KB)*/
@property(nonatomic) int usHistoryTraffic;

/** 表示该点的下行总流量,单位K字节 (Downlink traffic of this node, in KB)*/
@property(nonatomic) int dsHistoryTraffic;

@end
