#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 搜索到的网关信息(searched gateway information)
 *
 *  @since 1.0
 */
@interface HwSearchedUserGateway : NSObject

/** 网关MAC(最长128字节，UTF-8编码) (Gateway MAC address (128 bytes at most in UTF-8 code))*/
@property(nonatomic,copy)NSString *deviceMac;
/** 设备厂商 */
@property(nonatomic,copy)NSString *vendor;
/** 设备型号 */
@property(nonatomic,copy)NSString *model;
/** 是否支持密码认证 */
@property(nonatomic,assign)BOOL onlyPwdAuth;
/** 是否支持免密校验,仅供消费者用户使用 */
@property(nonatomic,assign) BOOL isSupportNoVerifyBindOnt;
/** "Failed"/ "Connected" */
@property(nonatomic,copy)NSString *platConnStatus;
/** 当前平台连接失败的原因 */
@property(nonatomic,copy)NSString *connFailReason;
/** 初始向导完成状态 */
@property(nonatomic,copy)NSString *configStatus;
/** 网关是否支持三联包特性，默认值为false，网关没有返回也是false */
@property(nonatomic,assign) BOOL isMultiPack;

@end
