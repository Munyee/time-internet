
#import <Foundation/Foundation.h>
/**
 *  
 *
 *  @brief 疑似蹭网设备(uspected Rubbing Lan Device)
 *
 *  @since 1.7
 */
@interface HwSuspectedRubbingLanDevice : NSObject
/** 设备MAC地址 (device mac) */
@property(nonatomic,copy) NSString *Mac;

/** 尝试连接次数 (retry count) */
@property(nonatomic,assign) NSInteger retryCount;

/** 最后尝试连接时间 (last Retry Time) */
@property(nonatomic,strong) NSDate *lastRetryTime;
@end
