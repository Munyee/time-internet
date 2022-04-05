//
//  HwSetGatewayAcsStartParam.h
//  MobileSDK
//
//  Created by wuwenhao on 18/3/27.
//  Copyright © 2018年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 频段类型

 - HwGatewayRadioTypeG2P4: 2.4G
 - HwGatewayRadioTypeG5: 5G
 */
typedef NS_ENUM(NSInteger , HwGatewayRadioType) {
    HwGatewayRadioTypeG2P4,
    HwGatewayRadioTypeG5,
};

@interface HwSetGatewayAcsStartParam : NSObject

@property (nonatomic , assign) HwGatewayRadioType radioType;

@end
