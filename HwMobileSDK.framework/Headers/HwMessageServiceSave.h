


#import <Foundation/Foundation.h>


@protocol HwCallback;
@class HwMessageQueryParam;
@class HwSendMessageData;
@class HwMessageHandleAdapter,HwCallbackAdapter;
/**
 家信消息的类型(Home message type  )
 */
typedef enum
{
    /** 告警消息 (Alarm message)*/
    kHwMessageTypeAlarm = 1,
    /** 聊天消息 (Chat message)*/
    kHwMessageTypeChat,
    /** 事件消息 (Event message)*/
    kHwMessageTypeEvent
}HwMessageType;

/**
 *
 * 家信消息服务(Home message service)
 *
 * 
 *
 */
@interface HwMessageServiceSave : NSObject

@end
