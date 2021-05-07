#import <Foundation/Foundation.h>

/**
 通知状态
 */
typedef enum
{
    /** 使能 */
    kHwNotificationStatusEnable = 1,
    /** 未使能 */
    kHwNotificationStatusDisable,
    /** 未配置 */
    kHwNotificationStatusNotBind
} HwNotificationStatus;

/**
 *  
 *
 *  @brief 通知配置
 *
 *  @since 1.7
 */
@interface HwNotificationConfig : NSObject

/** 短信通知状态 */
@property (nonatomic) HwNotificationStatus sms;

/** 邮件通知状态 */
@property (nonatomic) HwNotificationStatus email;

@end
