#import <Foundation/Foundation.h>
#import "HwCommonDefine.h"

@class HwShareGatewayAccount;

/**
 *  
 *
 *  @brief 分享网关请求参数
 *
 *  @since 1.7
 */
@interface HwShareGatewayParam : NSObject

/** 账户类型，目前只支持手机 */
@property(nonatomic,assign) HwAccountType accountType;

/** 发送方式。只支持手机方式 */
@property(nonatomic,assign) HwSendType sendType;

/** 账号信息列表 */
@property(nonatomic,strong) NSMutableArray<HwShareGatewayAccount *> *accountInfoList;

@end
