#import <Foundation/Foundation.h>
#import "HwCommonDefine.h"

@interface HwVerifyCodeForBindParam : NSObject

/** 绑定的手机号或邮箱 (Bound mobile number or email)*/
@property(nonatomic, copy) NSString *account;

/** 绑定类型 (Binding type)*/
@property(nonatomic) HwBindType bindType;

@end
