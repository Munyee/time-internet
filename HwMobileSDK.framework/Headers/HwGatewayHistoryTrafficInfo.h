#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 网关历史流量信息 (gateway historical traffic information)
 *
 *  @since 1.6.0
 */
@interface HwGatewayHistoryTrafficInfo : NSObject

/** 表示start点之前的上行总流量,单位K字节 (Total uplink traffic before the start node, in KB)*/
@property(nonatomic) int usTraffic;

/** 表示start点之前的下行总流量,单位K字节 (Total downlink traffic before the start node, in KB)*/
@property(nonatomic) int dsTraffic;

/** 历史流量 (Historical traffic)*/
@property(nonatomic, strong) NSMutableArray *gatewayHistoryTrafficList;

@end
