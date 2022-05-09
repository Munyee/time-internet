#import <Foundation/Foundation.h>

@interface HwTrafficInfo : NSObject

/** 信道号 (Channel number)*/
@property (nonatomic, copy) NSString *channel;

/** 路况值 (Channel condition value)*/
@property (nonatomic, copy) NSString *traffic;

/** AP个数 */
@property(nonatomic,assign) NSInteger apCount;
/**
 *  
 *
 *  @brief 自定义初始化方法(user-defined initialization method)
 *
 *  @param trafficStr 信道号(channel number)
 *  @param channel    路况值(channel condition value)
 *
 *  @return 返回初始化后的实例(Return the initialized instance.)
 *
 *  @since 1.0
 */
- (instancetype)initwithChannel:(NSString *)trafficStr withTraffic:(NSString *)channel;
@end
