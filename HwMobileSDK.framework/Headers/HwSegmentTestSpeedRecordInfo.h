//
//  HwSegmentTestSpeedRecordInfo.h
//  HwMobileSDK
//
//  Created by guozheng on 2019/4/25.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwSegmentTestSaveRecordParam.h"

NS_ASSUME_NONNULL_BEGIN


@class HwSegmentTestSpeedSubRecordInfo;

@interface HwSegmentTestSpeedRecordInfo : NSObject
/** 记录 id */
@property (nonatomic , copy) NSString *recordId;
/** 记录创建时间 */
@property (nonatomic , strong) NSDate *createDate;
/** 用户类型 */
@property (nonatomic , copy) NSString *userType;
/** 用户账号 */
@property (nonatomic , copy) NSString *userAccount;
/** 子记录列表 */
@property (nonatomic , strong) NSArray<HwSegmentTestSpeedSubRecordInfo *> *subRecordList;

@end



@interface HwSegmentTestSpeedSubRecordInfo : HwSegmentSpeedTestSaveSubRecordInfo
/** 子记录 id */
@property (nonatomic , copy) NSString *subRecordId;

@end
NS_ASSUME_NONNULL_END
