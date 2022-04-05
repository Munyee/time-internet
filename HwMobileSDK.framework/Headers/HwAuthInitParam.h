#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwParam.h>

/**
 *  
 *
 *  @brief 华为鉴权初始化参数(Huawei authentication initialization parameters)
 *
 *  @since 1.0
 */
@interface HwAuthInitParam : HwParam

/** 云平台IP (Cloud platform IP)*/
@property(nonatomic, copy) NSString *ip;

/** 云平台端口 (Cloud platform port)*/
@property(nonatomic) int port;

/** 本地化 (Localization)*/
@property(nonatomic, strong) NSLocale *locale;

/** domainId  */
@property(nonatomic, copy) NSString * domainId;
@end
