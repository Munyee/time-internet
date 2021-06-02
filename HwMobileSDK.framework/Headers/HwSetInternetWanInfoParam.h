//
//  HwSetInternetWanInfoParam.h
//  HwMobileSDK
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    kHwGatewayAddressingTypeUnknown,
    kHwGatewayAddressingTypeDHCP,
    kHwGatewayAddressingTypeStatic,
} kHwGatewayAddressingType;

typedef enum : NSUInteger {
    kHwGatewayConnectionTypeUnknown,
    kHwGatewayConnectionTypeIPRouted,
    kHwGatewayConnectionTypePPPoERouted,
} kHwGatewayConnectionType;

NS_ASSUME_NONNULL_BEGIN

@interface HwSetInternetWanInfoParam : NSObject

/**
 wanName
 */
@property (nonatomic, copy) NSString *wanName;

/**
 IP_Routed/PPPoE_Routed
 */
@property (nonatomic, assign) kHwGatewayConnectionType connectionType;

/**
 DHCP/Static
 */
@property (nonatomic, assign) kHwGatewayAddressingType addressingType;

/**
 ip
 */
@property (nonatomic, copy) NSString *ipAddress;

/**
 subNetMask
 */
@property (nonatomic, copy) NSString *subNetMask;

/**
 gateway
 */
@property (nonatomic, copy) NSString *gateway;

/**
 dns1
 */
@property (nonatomic, copy) NSString *dns1;

/**
 dns2
 */
@property (nonatomic, copy) NSString *dns2;

/**
 pppoe用户名
 */
@property (nonatomic, copy) NSString *pppoeUserName;

/**
 pppoe密码
 */
@property (nonatomic, copy) NSString *pppoePassword;

@end

NS_ASSUME_NONNULL_END
