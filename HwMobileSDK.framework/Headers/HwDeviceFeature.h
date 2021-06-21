//
//  HwDeviceFeature.h
//  MobileSDK
//
//  Created by guozheng on 17/2/27.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwDeviceFeature : NSObject
/** 特性名称 */
@property(nonatomic,copy) NSString *featureName;

/** 特性是否支持 */
@property(nonatomic,assign) BOOL hasFeature;

/** 特性附加信息：例如网关的规范 */
@property(nonatomic,copy) NSString *featureValue;

@end
