#import "HwSystemServiceSave.h"
#import "HwDeviceAccState.h"
#import "HwDeviceAccStrategy.h"

@protocol HwCallback;

@class HwNotificationConfig;
@class HwFeedbackInfo;
@class HwEvaluateParam;
@class HwGetFeedbackDetailParam;
@class HwGetFeedbackParam;
@class HwDownloadFeedbackPicturesParam;
@class HwDeleteFeedbackParam;
@class HwGetCloudFeatureParam;
/**
 *  
 *
 *  @brief 系统服务(system service)
 *
 *  @since 1.7
 */
@interface HwSystemService : HwSystemServiceSave

typedef void(^HwgetAppConfigHandleCallBack)(NSString* jsonStr);
typedef void(^HwgetAppConfigHandle)(NSString* tag,HwgetAppConfigHandleCallBack callback);

#pragma mark System Manage

/**
 *  
 *
 *  @brief 查询通知配置(Query the notification configuration.)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback callback
 *
 *  @since 1.7
 */
- (void)getNotificationConfig:(NSString *)deviceId withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 用户APP SDK支持登录后查询平台能力集
 *
 *  @param callback callback()
 *
 *  @since 1.7
 */
- (void)getCloudFeature:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 用户APP SDK支持未登录查询平台能力集
 *
 *  @param callback callback()
 *
 *  @since 1.7
 */
- (void)getCloudFeatureWithoutLogin:(HwGetCloudFeatureParam *)getCloudFeatureParam withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 设置通知配置(Set the notification configuration.)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param config   通知配置(notification configuration)
 *  @param callback callback
 *
 *  @since 1.7
 */
- (void)setNotificationConfig:(NSString *)deviceId
                   withConfig:(HwNotificationConfig *)config
                 withCallBack:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 注册APP和手机插件通信通道(get app config imformation listening cancelation)
 *
 *  @param HwgetAppConfigHandle     回调句柄
 *
 *  @since 1.7
 */
- (void)registerGetAppConfigHandle:(HwgetAppConfigHandle)handle;

/**
 *  
 *
 *  @brief 注册APP和手机插件通信通道(cancel app config imformation listening cancelation)
 *
 *  @param HwgetAppConfigHandle     回调句柄
 *
 *  @since 1.7
 */
- (void)unRegisterGetAppConfigHandle;
/**
 *  
 *
 *  @brief 查询消费者意见反馈列表
 *
 *  @param callback     callback
 *
 *  @since 1.0
 */
- (void)getUserFeedbacks:(HwGetFeedbackParam *)getFeedbackParam withCallback:(id<HwCallback>)callback;
/**
 *  
 *
 *  @brief 消费者对装维人员的回复进行评价
 *
 *  @param callback  callback
 *
 *  @since 1.0
 */
- (void)evaluate:(HwEvaluateParam *)evaluateParam withCallback:(id<HwCallback>)callback;
/**
 *  
 *
 *  @brief 查询反馈详情
 *
 *  @param callback  callback
 *
 *  @since 1.0
 */
- (void)getFeedbackDetail:(HwGetFeedbackDetailParam *)getFeedbackDetailParam withCallback:(id<HwCallback>)callback;

/**
 下载意见反馈上传的图片zip

 @param param 请求参数
 @param callback 回调
 */
- (void)downloadFeedbackPicturesWithParam:(HwDownloadFeedbackPicturesParam *)param withCallback:(id<HwCallback>)callback;

/**
 删除意见反馈(单条)

 @param param 请求参数
 @param callback 回调
 */
- (void)deleteFeedback:(HwDeleteFeedbackParam *)param withCallback:(id<HwCallback>)callback;

/**
 查询网络加速状态

 @param deviceId mac
 @param callback 回调 NSArray<HwDeviceAccState *>
 */
- (void)getAccStrategyState:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 设置网络加速状态

 @param deviceId mac
 @param list NSArray<HwDeviceAccStrategy *>
 @param callback 回调 HwResult
 */
- (void)setAccStrategyState:(NSString *)deviceId param:(NSArray <HwDeviceAccStrategy *>*)list withCallback:(id<HwCallback>)callback;
@end
