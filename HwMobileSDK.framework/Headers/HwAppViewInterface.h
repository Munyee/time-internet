#import <Foundation/Foundation.h>
#import "HwScannerResult.h"

/**
 原生界面类型(Original interface type)
 */
typedef enum
{
    /** 网络设备(Network device)*/
    kHwViewNameTypeMyNetWork = 1,
    /** 智能设备(Smart device)*/
    kHwViewNameTypeSmartDevice,
    /** 应用商场界面(Application store page)*/
    kHwViewNameTypeAppStore,
    /** 发现设备(Device discovery)*/
    kHwViewNameTypeFindSmartDevice,
    /** 智能设备(Smart device online)*/
    kHwViewNameTypeSmartDeviceOnline,
    /** 智能设备(Smart device offline)*/
    kHwViewNameTypeSmartDeviceOffline
}kHwViewNameType;

@class HwWebView,HwLocationResult;
/**
 *  
 *
 *  @brief 卡片视图等对外视图的回调接口，由AppSDK调用者实现(callback interfaces for external views such as widget views, implemented by the AppSDK invoker)
 *
 *  @since 1.0
 */
@protocol HwAppViewInterface<NSObject>
@optional
/**
 *  
 *
 *  @brief 插件打开原生界面(plug-in open original page)
 *
 *  @param hwViewerName 界面名称(interface name)
 *
 *  @return 成功／失败(succeeded/failed)
 *
 *  @since 1.0
 */
- (BOOL)openViewer:(kHwViewNameType)hwViewerName;


/**
 *  
 *
 *  @brief 插件打开原生界面(plug-in open original page)
 *
 *  @param viewerTarget 界面名称(viewer Target)
 *
 *  @return 成功／失败(succeeded/failed)
 *
 *  @since 1.0
 */
- (BOOL)openViewerByTarget:(NSString *)viewerTarget;

/**
 *  
 *
 *  @brief 插件打开原生界面视频存储(plug-in open original page)
 *
 *  @param viewerTarget 界面名称(viewer Target)
 *
 *  @param paramDic 传递参数(diction)
 *
 *  @return 成功／失败(succeeded/failed)
 *
 *  @since 1.0
 */
- (BOOL)openViewerByTarget:(NSString *)viewerTarget withParamDic:(NSDictionary *)paramDic;

/**
 *  
 *
 *  @brief 隐藏webview 外层View的头部(hide the header of an outer view of a webview)
 *
 *  @return 成功／失败(succeeded/failed)
 *
 *  @since 1.0
 */
- (BOOL)hideContainerViewTitleBar;

/**
 *  
 *
 *  @brief 显示webview 外层View的头部标题(display the header title of an outer view of a webview)
 *
 *  @return 成功／失败(succeeded/failed)
 *
 *  @since 1.0
 */
- (BOOL)showContainerViewTitleBar;

/**
 *  
 *
 *  @brief 设置webview外层View的头部标题(set the header title of an outer view of a webview)
 *
 *  @param title 头部标题(header title)
 *
 *  @return 成功／失败(succeeded/failed)
 *
 *  @since 1.0
 */
- (BOOL)setContainerViewTitleBar:(NSString *)title;

/**
 *  
 *
 *  @brief 关闭webview 外层View页面(close an outer view page of a webview)
 *
 *  @return 成功／失败(succeeded/failed)
 *
 *  @since 1.0
 */
- (BOOL)closeContainerView;


/**
 *  
 *
 *  @brief 打开包裹webview的View页面(open a view page of a package webview)
 *
 *  @param webView webview句柄(webview handle)
 *  @param title   头部标题(header title)
 *
 *  @return 成功／失败(succeeded/failed)
 *
 *  @since 1.0
 */
- (BOOL)openContainerView:(HwWebView *)webView andTitle:(NSString *)title;

/**
 *  
 *
 *  @brief 打开二维码扫描页面(open a QR code scanning page)
 *
 *  @param callBack 返回扫描结果(returned scanning result)
 *
 *  @since 1.0
 */
- (void)scan:(void(^)(HwScannerResult *scanResult))callBack;

/**
 *  
 *
 *  @brief 打开条形码扫描页面
 *
 *  @param callBack
 *
 *  @since 1.0
 */
- (void)scanBarcode:(void(^)(HwScannerResult *scanResult))callBack;


/**
 *  
 *
 *  @brief 获取位置信息
 *
 *  @param callBack
 *
 *  @since 1.0
 */
- (void)getLocation:(void(^)(HwLocationResult *scanResult))callBack;


/**
 *  
 *
 *  @brief 打开图片选择页面(open a picture selection page)
 *
 *  @return 返回选择的图片列表(return a selected picture list)
 *
 *  @since 1.0
 */
- (NSArray *)chooseFiles;

- (BOOL)chooseFilesWithPath:(NSString *)url;
/**
 *  
 *
 *  @brief 打开图片查看页面，显示图片(open a picture view page to display a picture)
 *
 *  @param url url地址(url)
 *
 *  @return 图片地址(picture address)
 *
 *  @since 1.0
 */
- (BOOL)openImageViewer:(NSString *)url;

/**
 *  
 *
 *  @brief 打开视频播放界面播放视频(open video playback page to play a video)
 *
 *  @param url 视频地址(video address)
 *
 *  @return 成功／失败(succeeded/failed)
 *
 *  @since 1.0
 */
- (BOOL)openVideoViewer:(NSString *)url;

/**
 *  
 *
 *  @brief  打开图片选择页面
 *
 *  @return 图片的数组
 *
 *  @since 1.0
 */
- (void)chooseImages:(void(^)(NSString *imgPathStr))callBack;

/**
 *  
 *
 *  @brief 签名
 *
 *  @param callBack
 *
 *  @since 1.0
 */
- (void)sign:(void(^)(NSString *imgPathStr))callBack;

/**
 *
 *
 *  @brief 获取插件资源文件
 *
 *  @param callBack
 *
 *  @since 1.0
 */
- (id )getPluginResource:(NSString *)resourcePath;

- (NSString *)getAppStyle;


- (BOOL)setBarStyle:(NSDictionary *)param;

@end


