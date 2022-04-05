#import <Foundation/Foundation.h>

/**
 VOIP注册类型(VOIP registration type)
 */
typedef NS_ENUM(NSInteger, HwLineStatus) {
    /** 注册成功 (Registration succeeded)*/
    kVoipStatusSuccess = 1,
    /** 注册失败、无有效的VOIP连接 (Registration failed, and no valid VOIP connection)*/
    kVoipStatusNovalidConnection,
    /** 注册失败、IAP模块错误 (Registration failed, and IAP module error)*/
    kVoipStatusIadError,
    /** 注册失败、访问路由不通 (Registration failed, and access route unavailable)*/
    kVoipStatusNoRoute,
    /** 注册失败、访问服务器无响应 (Registration failed, and no response to a server access attempt)*/
    kVoipStatusNoResponse,
    /** 注册失败、账号错误 (Registration failed, and account error)*/
    kVoipStatusAccountErr, // DOC_CHANGE
    /** 注册失败、未知错误 (Registration failed, and unknown error)*/
    kVoipStatusUnknow
};

/**
 *  
 *
 *  @brief VOIP注册状态(VOIP registration status)
 *
 *  @since 1.0
 */
@interface HwVoipRegStatus : NSObject

/** 线路1 (Line 1)*/
@property(nonatomic) HwLineStatus line1Status; // DOC_CHANGE

/** 线路2 (Line 2)*/
@property(nonatomic) HwLineStatus line2Status;

@end
