#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief  通用定义(general definition)
 *
 *  @since 1.0
 */
@interface HwCommonDefine : NSObject

/**
 账户类型(Account type)
 */
typedef enum
{
    /** 账号方式 (By account)*/
    kHwAccountTypeAccount = 1,
    /** 手机方式 (By mobile phone) */
    kHwAccountTypePhone = 2,
    /** 邮箱方式 (By email)*/
    kHwAccountTypeEmail = 3
} HwAccountType;

/**
 找回密码找回方式(Password retrieval mode)
 */
typedef enum
{
    /** 账号方式 (By account) */
    kHwFindpwdFindTypeAccount = 1,
    /** 手机方式 (By mobile phone)*/
    kHwFindpwdFindTypePhone,
    /** 邮箱方式 (By email)*/
    kHwFindpwdFindTypeEmail
} HwFindpwdFindType;

/**
 信息发送方式(Password retrieval mode)
 */
typedef enum
{
    /** 手机方式 (By mobile phone)*/
    kHwSendTypePhone = 1,
    /**  微信方式(By We_chat)*/
    kHwSendTypeWe_Chat = 2,
    /** 自行加入()*/
    kHwSendTypeOneSelf = 3,
    /** 邮箱方式 (By email)*/
    kHwSendTypeEmail = 4,
    /** All */
    kHwSendTypeAll = 5,
    /** 账号方式 (by Account)*/
    kHwSendTypeAccount = 6
} HwSendType;

/**
 绑定类型(Binding type)
 */
typedef enum
{
    /** 手机方式 (By mobile phone)*/
    kHwBindTypePhone = 1,
    /** 邮箱方式 (By email)*/
    kHwBindTypeEmail
} HwBindType;

/**
 一周的星期定义(definition of days of a week)
 */
typedef enum
{
    kHwDayOfWeekMon = 1,
    kHwDayOfWeekTue,
    kHwDayOfWeekWed,
    kHwDayOfWeekTus,
    kHwDayOfWeekFri,
    kHwDayOfWeekSat,
    kHwDayOfWeekSun,
} kHwDayOfWeek;

/**
 值类型(Value type)
 */
typedef enum
{
    kHwValueTypeUnknow = 0,
    kHwValueTypeString,
    kHwValueTypeInt,
    kHwValueTypeFloat,
    kHwValueTypeEnum
} kHwValueType;

/**
    AP支持的频段类别(Frequency band types supported by the AP)
 */
typedef enum : NSUInteger {
    kHwRadioTypeG2P4 = 1,
    kHwRadioTypeG5,
    kHwRadioTypeAll
} HwRadioType;

/**
 循环周期类型(mode of repeat)
 */
typedef enum
{
    kHwRepeatModeNone = 1,
    kHwRepeatModeDay = 2,
    kHwRepeatModeWeek = 3
}HwRepeatMode;
@end
