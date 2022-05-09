//
//  HwSegmentTestGetHistoryRecordParam.h
//  HwMobileSDK
//
//  Created by guozheng on 2019/4/25.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwSegmentSpeedTestMacro.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwSegmentTestGetHistoryRecordParam : NSObject
/** 网关 mac */
@property (nonatomic , copy) NSString *mac;
/** 起始时间 */
@property (nonatomic , strong) NSDate *startDate;
/** 结束时间 */
@property (nonatomic , strong) NSDate *endDate;
/** 最大记录数 */
@property (nonatomic , assign) NSInteger limitCount;
/** 起始 */
@property (nonatomic , assign) NSInteger offset;
/** 分段测速0，一键测速1 */
@property (nonatomic , copy) NSString *testType;
/** 测速维度 */
@property (nonatomic , assign) HwSegmentSpeedTestDimension dimension;
/** 维度的设备 MAC | 对于 FAMILY 来说，就是网关 MAC，对于 STA ，就是 STA 的 MAC */
@property (nonatomic , copy) NSString *dimensionDeviceId;

@end

NS_ASSUME_NONNULL_END
