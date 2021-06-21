#import <Foundation/Foundation.h>
#import "HwApplicationServiceSave.h"

@class HwApplicationDoActionParam;

/**
 *  
 *
 *  @brief 应用超市服务(application supermarket service)
 *
 *  @since 1.0
 */
@interface HwApplicationService : HwApplicationServiceSave


/**
 *  
 *
 *  @brief 查询本地应用列表(query an local application list)
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.7
 */
- (void)queryAllLocalAppList:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 安装应用(application installation)
 *
 *  @param appId    应用ID(最长64字节)(application ID (64 bytes at most))
 *  @param deviceId 网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)installApp:(NSString *)appId withDeviceId:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 升级应用(upgrade application)
 *
 *  @param appId    应用ID(最长64字节)(application ID (64 bytes at most))
 *  @param deviceId 网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)upgradeApp:(NSString *)appId withDeviceId:(NSString *)deviceId withCallback: (id<HwCallback>) callback;

/**
 *  
 *
 *  @brief 卸载应用(remove an app)
 *
 *  @param appId    应用ID(最长64字节)(application ID (64 bytes at most))
 *  @param deviceId 网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)unInstallApp:(NSString *)appId withDeviceId:(NSString *)deviceId withCallback: (id<HwCallback>) callback;


/**
 *  
 *
 *  @brief 应用插件操作命令透传接口
 *
 *  @param deviceId 设备SN(最长128字节) (device SN, containing a maximum of 128 bytes)
 *  @param param    command param
 *  @param callBack
 *
 *  @since
 */
- (void)doAction:(NSString *)deviceId
       withParam:(HwApplicationDoActionParam *)param
    withCallback:(id<HwCallback>)callBack;

@end
