#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 消息通知类型(notification type)
 *
 *  @since 1.7
 */
typedef NS_ENUM(NSInteger, HwMessageSendOptionTypeEnum) {
    /** Message */
    kHwHwMessageSendOptionTypeEnumMessage = 1,
    /** Email */
    kHwHwMessageSendOptionTypeEnumEmail,
    /** SMS */
    kHwHwMessageSendOptionTypeEnumSms
};

/**
 *  
 *
 *  @brief 消息通知类型(notification type)
 *
 *  @since 1.7
 */
@interface HwMessageSendOption : NSObject

/** 消息名称(message name) */
@property(nonatomic, copy) NSString *name;

/** 消息开关(message switch) */
@property(nonatomic) BOOL messageSwitch;

/** 通知类型(notification type) */
@property(nonatomic, strong) NSSet<NSNumber */* HwMessageSendOptionTypeEnum */> *typeList;

@end
