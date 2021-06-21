#import <Foundation/Foundation.h>
#import "HwCommonDefine.h"

/**
 发送方式(Sending mode)
 */
typedef enum
{
    kHwFindpwdSendTypePhone = 1,
    kHwFindpwdSendTypeEmail,
    kHwFindpwdSendTypeAll
} HwFindpwdSendType;

@interface HwVerifyCodeForFindpwdParam : NSObject

/** 账号 (Account)*/
@property(nonatomic, copy) NSString *account;

/** 找回方式 (Retrieval mode)*/
@property(nonatomic) HwFindpwdFindType findType;

/** 发送方式 (Sending mode)*/
@property(nonatomic) HwFindpwdSendType sendType;

@end
