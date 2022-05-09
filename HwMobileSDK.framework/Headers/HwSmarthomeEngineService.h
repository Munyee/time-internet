#import <Foundation/Foundation.h>

#import <HwMobileSDK/HwCallback.h>
#import <HwMobileSDK/HwAppViewInterface.h>

#import <HwMobileSDK/HwWebView.h>
#import <HwMobileSDK/HwWidgetMeta.h>

#import <HwMobileSDK/HwSmarthomeEngineSaveService.h>

/**
 智慧家居集成(Smart home integration)
 */
@interface HwSmarthomeEngineService : HwSmarthomeEngineSaveService


#pragma mark 视图集成(view integration)

/**
 *
 *
 *  @brief 创建传感器控制视图(sensor creation control view)
 *
 *  @param deviceId 网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param deviceSn 要控制的设备SN(最长128字节)(SN of the device to be controlled (128 bytes at most))
 *  @param appViewInterface 视图回调(view callback)
 *
 *  @return 相应的视图(corresponding views)
 *
 *  @since 1.0
 */
- (HwWebView *)createProductControlView:(NSString *)deviceId
                           withDeviceSn:(NSString *)deviceSn
                          withInterface:(id<HwAppViewInterface>)appViewInterface;

/**
 *
 *
 *  @brief 创建卡片视图(creating a widget view)
 *
 *  @param deviceId 网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param appViewInterface 视图回调(view callback)
 *
 *  @return 相应的视图(corresponding views)
 *
 *  @since 1.0
 */
- (HwWebView *)createWidgetView:(NSString *)deviceId
                  withInterface:(id<HwAppViewInterface>)appViewInterface;

/**
 *
 *
 *  @brief 创建卡片视图(creating a widget view)
 *
 *  @param deviceId 网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @parm widgetList 需要显示的卡片列表，传了该参数后，列表中没有的卡片将不显示；传nil或空数组则认为显示所有卡片
 *  @param appViewInterface 视图回调(view callback)
 *
 *  @return 相应的视图(corresponding views)
 *
 *  @since 1.0
 */
- (HwWebView *)createWidgetView:(NSString *)deviceId
                 withWidgetList:(NSArray<HwWidgetMeta *> *)widgetList
                  withInterface:(id<HwAppViewInterface>)appViewInterface;

/**
 *
 *
 *  @brief 创建产品安装指引视图(create a product installation guide view)
 *
 *  @param manufacturer 厂商名称(最长64字节)(manufacturer name (64 bytes at most))
 *  @param productName  产品名称(产品名称在厂商中唯一)(最长64字节)(product name (unique in the vendor) (64 bytes at most))
 *  @param appViewInterface 视图回调(view callback)
 *
 *  @return 相应的视图(corresponding views)
 *
 *  @since 1.0
 */
- (HwWebView *)createProductGuideView:(NSString *)manufacturer
                      withProductName:(NSString *)productName
                        withInterface:(id<HwAppViewInterface>)appViewInterface;


/**
 *
 *
 *  @brief 创建产品安装指引视图(create a product installation guide view)
 *  @note 需要传 deviceId
 *
 *  @param deviceId 设备id(device id)
 *  @param manufacturer 厂商名称(最长64字节)(manufacturer name (64 bytes at most))
 *  @param productName  产品名称(产品名称在厂商中唯一)(最长64字节)(product name (unique in the vendor) (64 bytes at most))
 *  @param appViewInterface 视图回调(view callback)
 *
 *  @return 相应的视图(corresponding views)
 *
 *  @since 1.0
 */
- (HwWebView *)createProductGuideViewWithDeviceId:(NSString *)deviceId
                                     manufacturer:(NSString *)manufacturer
                                      productName:(NSString *)productName
                                        interface:(id<HwAppViewInterface>)appViewInterface;

/**
 *
 *
 *  @brief 升级插件(upgrading a plug-in)
 *
 *  @param deviceId 网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param callback 返回回调(return  callback)
 *
 *  @since 1.0
 */
- (void)upgrade:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 根据url创建视图
 *
 *  @param deviceId         网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param url                视图地址
 *  @param appViewInterface 视图回调(view callback)
 *
 *  @return 相应的视图(corresponding views)
 *
 *  @since 1.0
 */
- (HwWebView *)createUrlWebView:(NSString *)deviceId
                        withUrl:(NSString *)url
                  withInterface:(id<HwAppViewInterface>)appViewInterface;

/**
 *
 *
 *  @brief 创建应用视图(Create an application view.)
 *
 *  @param deviceId         网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param name             应用的名称(application name)
 *  @param appViewInterface appViewInterface 视图回调(view callback)
 *
 *  @return 相应的视图(corresponding views)
 *
 *  @since 1.0
 */
- (HwWebView *)createAppView:(NSString *)deviceId
                    withName:(NSString *)name
               withInterface:(id<HwAppViewInterface>)appViewInterface;

@end
