//
//  HwInternetSpeedTestConfigInfo.h
//  HwMobileSDK
//
//  Created by guozheng on 2019/4/24.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwSegmentSpeedTestMacro.h"
#import "HwSegmentSpeedTestSubModels.h"

NS_ASSUME_NONNULL_BEGIN
@interface HwInternetSpeedTestConfigInfo : NSObject
/** internet 测速激活状态 */
@property (nonatomic , assign) HwSegmentSpeedTestConfigState state;
/** internet 测速协议 */
@property (nonatomic , assign) HwSegmentSpeedTestConfigProtocol protocol;
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestInternetUrlInfo *> *urlInfoList;
@end


@interface HwDurationSpeedTestConfigInfo : NSObject
/** 到 Internet 的测速时长，包括【STA/AP/网关 到 Internet 之间】 */
@property (nonatomic , copy) NSString *durationToInternet;
/** 到 家庭网关 的测速时长，包括【STA/AP 到 网关 之间】 */
@property (nonatomic , copy) NSString *durationToHomeGateway;
/** 到 AP 的测速时长，包括【STA/AP 到 AP 之间】 */
@property (nonatomic , copy) NSString *durationToAp;
@end


@interface HwSpeedTestConfigInfo : NSObject
/** 测速时长 */
@property (nonatomic , strong) HwDurationSpeedTestConfigInfo *durationConfigInfo;
/** Internet 测速配置信息 */
@property (nonatomic , strong) HwInternetSpeedTestConfigInfo *internetConfigInfo;
@end
NS_ASSUME_NONNULL_END
