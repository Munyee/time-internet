//
//  HwSegmentSpeedResult.h
//  HwMobileSDK
//
//  Created by IOS2 on 2020/7/28.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwGetSegmentSpeedResult.h>
NS_ASSUME_NONNULL_BEGIN

@interface HwSegmentSpeedResult : NSObject
/** sta-inernet测速启动状态码 */
@property (nonatomic , copy) NSString *staInternetStartUpStatus;
/** 网关段的测速启动状态码*/
@property (nonatomic , copy) NSString *ontStartUpStatus;
/** 网关返回的taskid */
@property (nonatomic , copy) NSString *ontTaskId;
/** 各分段的测速结果集合 */
@property (nonatomic , strong) NSArray<HwGetSegmentSpeedResult *> *segmentSpeedResultList;
@end

NS_ASSUME_NONNULL_END
