#import <Foundation/Foundation.h>

#import "HwMessageServiceSave.h"
#import "HwNotificationMessage.h"

@protocol HwCallback;
@class HwUploadSuccessData;
@class HwMessageQueryParam;
@class HwSendMessageData;
@class HwSendMessageToOMUserData;

@class HwMessageHandleAdapter,HwCallbackAdapter;
/**
 * 
 * 家信消息服务(Home message service)
 * 
 * 
 *
 */
@interface HwMessageService : HwMessageServiceSave

/**
 *  
 *
 *  @brief 家信消息监听( home message listening)
 *
 *  @param callBackAdapterHandle 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)registerMessageHandle:(HwMessageHandleAdapter *) messageHandle;

/**
 *  
 *
 *  @brief 家信消息取消监听(home message listening cancelation)
 *
 *  @param callBackAdapterHandle 返回回调(returns callback)
 *
 *  @since 1.0
 */
- (void)unregisterMessageHandle:(HwCallbackAdapter*) callBackAdapterHandle;

/**
 *  
 *
 *  @brief 根据 deviceId 查询消息(query messages)
 *
 *  @param deviceId     家庭 id （device id）
 *  @param messageQueryParam     消息参数类(message parameters)
 *  @param callBackAdapterHandle 回调(callback)
 *
 *  @since 1.0
 */
- (void)queryMessageWithDeviceId:(NSString *)deviceId
                           param:(HwMessageQueryParam *)msgParam
                        callback:(HwCallbackAdapter*) callBackHandle;

/**
 *  
 *
 *  @brief 查询消息(query messages)
 *
 *  @param messageQueryParam     消息参数类(message parameters)
 *  @param callBackAdapterHandle 回调(callback)
 *
 *  @since 1.0
 */
- (void)queryMessage:(HwMessageQueryParam *)messageQueryParam
        withCallback:(HwCallbackAdapter *)callBackAdapterHandle;

/**
 *  
 *
 *  @brief 根据SN列表查询消息(message query based on an SN list )
 *
 *  @param messageQueryParam     消息查询参数类(message query parameters)
 *  @param snList                消息SN列表(message SN list)
 *  @param callBackAdapterHandle 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)queryMessage:(HwMessageQueryParam *)messageQueryParam
          withSnList:(NSArray *)snList
        withCallback:(HwCallbackAdapter*)callBackAdapterHandle;

/**
 *  
 *
 *  @brief 发送聊天消息(send chat message.)
 *
 *  @param HwSendMessageData 消息对象(message data)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.7
 */
-(void)sendMessage:(HwSendMessageData *)sendMessageData withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询租户域下的装维用户（query omuser list）
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getOmuserListWithCallback:(id<HwCallback>)callback;
/**
 注册 token 和 clientId 信息失效通知
 
 @param handler 回调
 */
- (void)registerErrorMessageHandle:(void (^)(HwNotificationMessage *note))handler;

@end
