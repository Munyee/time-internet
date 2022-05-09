

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <HwMobileSDK/HwAppViewInterface.h>

@class HLJSBridge;
/**
 *  
 *
 *  @brief 华为WebView(Huawei WebView)
 *
 *  @since 1.0
 */
@interface HwWebViewSave : WKWebView <HwAppViewInterface>

/** Webview Javascript bridge对象 (Webview Javascript bridge object)*/
@property(nonatomic, strong) HLJSBridge *appJsBridge;

@property(nonatomic, copy) NSString *deviceId;

@property(nonatomic, weak) id <HwAppViewInterface> delegate;

/**
 *  
 *
 *  @brief 销毁方法;用于关闭视频通道等特殊功能，请在需要销毁时调用;一般来说在锁屏、切换到后台、播放页面关闭等场景需要调用destroy方法；锁屏场景下，需要App申请一小段后台运行时间(例如UIBackgroundTask)，避免销毁还未结束就被iOS系统挂起了(destroy method. It is invoked when destroy is required for special functions such as disabling a video channel. Usually it is invoked in scenarios like locking the screen, switching to the background, and closing the play page. In locking screen scenario, a short period for background running (for example, UIBackgroundTask) should be applied for on the app. Otherwise, the function may be mounted by the iOS before the destroy ends.
 *  @since 1.7
 */
- (void)destroy;

@end

