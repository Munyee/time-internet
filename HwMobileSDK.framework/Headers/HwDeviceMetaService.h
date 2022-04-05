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

- (HwProductMeta *)getProduct:(NSString *)manufactor productName:(NSString *)productName;

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

/// 获取插件的根目录
+ (NSString *)getPluginRootPath;

@end
