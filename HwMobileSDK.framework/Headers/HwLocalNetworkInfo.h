

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kHwLockNetworkStatusYES = 1,
    kHwLockNetworkStatusNO,
} HwLocalNetworkStatus;

typedef enum : NSUInteger {
    kHwNeedLoginGatewayYES = 1,
    kHwNeedLoginGatewayNO,
} HwNeedLoginGateway;

@interface HwLocalNetworkInfo : NSObject

/** 是否近端接入网关 (Whether a gateway is a local access gateway)*/
@property (nonatomic, assign) HwLocalNetworkStatus localNetworkStatus;

/** 是否需要登录 (Whether login is required) */
@property (nonatomic, assign) HwNeedLoginGateway loginGatewayStatus;

/**
 *  
 *
 *  @brief 自定义初始化方法(user-defined initialization method)
 *
 *  @param networkStatus 是否近端接入网关(Whether a gateway is a local access gateway.)
 *  @param isNeedLogin   是否需要登录(Whether login is required.)
 *
 *  @return 返回自身的实例(Return own instances.)
 *
 *  @since 1.0
 */
- (instancetype)initWithLocalNetworkStatus:(HwLocalNetworkStatus)networkStatus
                      withNeedLoginGateway:(HwNeedLoginGateway)isNeedLogin;
@end
