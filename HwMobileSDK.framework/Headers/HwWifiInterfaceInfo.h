#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 查询WLAN接口信息 (query WLAN interface information)
 *  @since 1.0
 */
@interface HwWifiInterfaceInfo : NSObject

@property(nonatomic, assign) BOOL enable;
@property(nonatomic, assign) int channel;

@end
