//
//  HwGetHomeNetworkTrafficInfoListConfig.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/12.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwGetHomeNetworkTrafficInfoListConfig : NSObject

/** 起始时间 */
@property (nonatomic , strong) NSDate *startTime;
/** 结束时间 */
@property (nonatomic , strong) NSDate *endTime;

@end

NS_ASSUME_NONNULL_END
