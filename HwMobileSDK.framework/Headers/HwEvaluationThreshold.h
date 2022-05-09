//
//  HwEvaluationThreshold.h
//  HwMobileSDK
//
//  Created by ios on 2021/10/27.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwEvaluationThreshold : NSObject

@property (nonatomic, assign) float wifiStaSignalIntensity2p4gGood;

@property (nonatomic, assign) float wifiStaSignalIntensity2p4gPoor;

@property (nonatomic, assign) float wifiStaSignalIntensity2p4gVeryPoor;

@property (nonatomic, assign) float wifiStaSignalIntensity5gGood;

@property (nonatomic, assign) float wifiStaSignalIntensity5gPoor;

@property (nonatomic, assign) float wifiStaSignalIntensity5gVeryPoor;

@property (nonatomic, assign) float linkNegorate2p4gGood;

@property (nonatomic, assign) float linkNegorate2p4gPoor;

@property (nonatomic, assign) float linkNegorate5gGood;

@property (nonatomic, assign) float linkNegorate5gPoor;

@property (nonatomic, assign) float externapUplinkNegorate5gGood;

@property (nonatomic, assign) float externapUplinkNegorate5gPoor;

@property (nonatomic, assign) float apRepeaterSignalIntensity2p4gGood;

@property (nonatomic, assign) float apRepeaterSignalIntensity2p4gPoor;

@property (nonatomic, assign) float apRepeaterSignalIntensity5gGood;

@property (nonatomic, assign) float apRepeaterSignalIntensity5gPoor;

- (NSDictionary *)modelToDic;

@end

NS_ASSUME_NONNULL_END
