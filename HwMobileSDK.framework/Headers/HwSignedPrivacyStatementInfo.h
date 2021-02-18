//
//  HWSignedPrivacyStatementInfo.h
//  HwMobileSDK
//
//  Created by zhangbin on 2019/4/23.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwSignedRecord.h"
#import "HwCommonSignPrivacyStatementResult.h"

NS_ASSUME_NONNULL_BEGIN
@class HLSignedPrivacyStatementInfo;
@interface HwSignedPrivacyStatementInfo : NSObject

@property (nonatomic, strong) HwCommonSignPrivacyStatementResult *commonSignPrivacyStatementResult;

@property (nonatomic, strong) HwSignedRecord *signedRecord;

+(HwSignedPrivacyStatementInfo *)modelFromInnerModel:(HLSignedPrivacyStatementInfo *)signedPrivacyStatementInfoInner;
@end

NS_ASSUME_NONNULL_END
