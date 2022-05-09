/**
 *  
 *
 *  @brief 设备特性服务集成 (device feature service integration)
 *
 *  @since 1.0
 */

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwCallbackAdapter.h>

@interface HwDeviceFeatureService : NSObject

/**
 *  
 *
 *  @brief 获取网关特性列表 (get device feature list)
 *
 *  @param deviceId 网关ID(最长128字节) (gateway ID, containing a maximum of 128 bytes)
 *  @param featureList 特性列表过滤条件 (feature filter list)
 *  @param callBack
 *
 *  @since 1.0
 */
-(void)getFeatureList:(NSString *)deviceId
      withFeatureList:(NSArray *)featureList
         withCallback:(id<HwCallback>)callBack;
@end

