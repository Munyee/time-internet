#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 查询网关历史流量请求参数 (historical gateway traffic query request parameters)
 *
 *  @since 1.6.0
 */
@interface HwQueryGatewayHistoryTrafficConditionParam : NSObject

/** 开始查询的记录点，表示从查询时刻向已经过去的时间方向数start-1个点开始查询，start不能为0 (Recording node from which the query starts. The query starts from the node numbered start–1 in the time direction from the query time, and start cannot be 0.)*/
@property (nonatomic) int start;

/** 查询从start点开始向当前时间方向的记录个数。如果查询的记录数num大于start点后网关已经记录的采集数目X，则只会查询到X对(上下行)数据。如果num为0，则表示查询start点后到最新记录的所有数据 (Number of records in the current time direction from the start node. If the record number num exceeds the number of records that the gateway already collected after the start node, X, only X pairs of uplink/downlink data can be queried. If num is 0, all data from the start node to the latest records are queried.)*/
@property (nonatomic) int number;

@end
