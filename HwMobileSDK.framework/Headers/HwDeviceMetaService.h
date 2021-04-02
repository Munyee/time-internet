#import <Foundation/Foundation.h>

@class HwProductMeta;
@class HwWidgetMeta;
@class HwAppMeta;
@class HwAlarmMeta;

/**
 *  
 *
 *  @brief 智能家居元数据服务(smart home metadata service)
 *
 *  @since 1.0
 */
@interface HwDeviceMetaService : NSObject

- (void)analyzPlugins;

/**
 *  
 *
 *  @brief 获取支持的厂商列表(obtain a list of supported vendors)
 *
 *  @return 支持的厂商列表(a list of supported vendor)
 *
 *  @since 1.0
 */
- (NSMutableArray *)getSupportedManufacturerList;

/**
 *  
 *
 *  @brief 获取厂商支持的产品列表(obtain a list of products supported by a vendor)
 *
 *  @param manufactor 厂商(最长64字节)(manufacturer (64 bytes at most))
 *
 *  @return 产品列表(product list)
 *
 *  @since 1.0
 */
- (NSMutableArray *)getSupportedProductList:(NSString *)manufactor;

/**
 *  
 *
 *  @brief 获取产品元数据信息(obtain product metadata information)
 *
 *  @param manufactor  厂商(最长64字节)(manufacturer (64 bytes at most))
 *  @param productName 产品名称(最长64字节)(productName (64 bytes at most))
 *
 *  @return 产品元数据(product metadata)
 *
 *  @since 1.0
 */
- (HwProductMeta *)getProduct:(NSString *)manufactor productName:(NSString *)productName;

/**
 *  
 *
 *  @brief 获取产品支持的动作列表(obtain a list of actions supported by a product)
 *
 *  @param manufactor  厂商(最长64字节)(manufacturer (64 bytes at most))
 *  @param productName 产品名称(最长64字节)(productName (64 bytes at most))
 *
 *  @return 动作列表(action list)
 *
 *  @since 1.0
 */
- (NSMutableArray *)getSupportedActionList:(NSString *)manufactor productName:(NSString *)productName;

/**
 *  
 *
 *  @brief 获取产品支持的场景动作列表(obtain a list of actions supported by a product used in ifttt)
 *
 *  @param manufactor  厂商(最长64字节)(manufacturer (64 bytes at most))
 *  @param productName 产品名称(最长64字节)(productName (64 bytes at most))
 *
 *  @return 动作列表(action list)
 *
 *  @since 1.0
 */
- (NSMutableArray *)getSupportedIftttActionList:(NSString *)manufactor productName:(NSString *)productName;
/**
 *  
 *
 *  @brief 获取产品支持的告警列表(obtain a list of alarms supported by a product)
 *
 *  @param manufactor  厂商(最长64字节)(manufacturer (64 bytes at most))
 *  @param productName 产品名称(最长64字节)(productName (64 bytes at most))
 *
 *  @return 告警列表(alarm list)
 *
 *  @since 1.0
 */
- (NSMutableArray *)getSupportedAlarmList:(NSString *)manufactor productName:(NSString *)productName;

/**
 *  
 *
 *  @brief 获取产品支持的告警列表(依赖核心插件，alarms 中有和核心插件相同的，以核心插件为准)(obtain a list of alarms supported by a product)
 *
 *  @param manufactor  厂商(最长64字节)(manufacturer (64 bytes at most))
 *  @param productName 产品名称(最长64字节)(productName (64 bytes at most))
 *
 *  @return 告警列表(alarm list)
 *
 *  @since 1.0
 */
- (NSMutableArray<HwAlarmMeta *> *) getSupportedAlarmListArrayDependKernel:(NSString *)manufacturer withProductName:(NSString *)productName;

/**
 *  
 *
 *  @brief 获取产品支持的触发条件列表(obtain a list of trigger conditions supported by a product)
 *
 *  @param manufactor  厂商(最长64字节)(manufacturer (64 bytes at most))
 *  @param productName 产品名称(最长64字节)(productName (64 bytes at most))
 *
 *  @return 出发条件列表(trigger condition list)
 *
 *  @since 1.0
 */
- (NSMutableArray *)getSupportedTriggerList:(NSString *)manufactor productName:(NSString *)productName;

/**
 *  
 *
 *  @brief  获取系统支持卡片列表(obtain a list of widgets supported by the system)
 *
 *  @return 产品支持的卡片列表(a list of widgets supported by a product)
 *
 *  @since 1.0
 */
- (NSMutableArray *)getWidgetList;

/**
 *  
 *
 *  @brief  获取系统支持APP列表(obtain a list of apps supported by the system)
 *
 *  @return 支持的app列表(a list of apps supported by system)
 *
 *  @since 1.0
 */
- (NSMutableArray *)getAppList;
/**
 *  
 *
 *  @brief 获取系统支持卡片元数据(obtain metadata of widgets supported by the system)
 *
 *  @param widgetName 卡片名(widgetName)
 *
 *  @return 卡片元数据(widget metadata)
 *
 *  @since 1.0
 */
- (HwWidgetMeta *)getWidget:(NSString *)widgetName;

/**
 *  
 *
 *  @brief 查询系统支持的家庭网络应用列表(Query the list of home network applications supported by the system.)
 *
 *  @return 返回对象的数组(array of returned objects)
 *
 *  @since 1.0
 */
- (NSMutableArray *)getHomeNetworkAppList;

/**
 *  
 *
 *  @brief 查询系统指定应用的元数据(Query the metadata of the application specified by the system.)
 *
 *  @param 应用名称(application name)
 *
 *  @return 返回查询到的指定的结果(Return the specified query result.)
 *
 *  @since 1.0
 */
- (HwAppMeta *)getApp:(NSString *)appName;

/// 获取预置插件地址
+ (NSString *)getPluginDefaultPath;

@end
