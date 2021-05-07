//
//  HWCommonSignPrivacyStatementResult.h
//  HwMobileSDK
//
//  Created by zhangbin on 2019/5/10.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLCommonSignPrivacyStatementResult;
@interface HwCommonSignPrivacyStatementResult : NSObject
/** 申明的下载地址 */
@property (nonatomic, copy) NSString *downloadUrl;
/** 申明的最新版本 */
@property (nonatomic, copy) NSString *latestVersion;
+(HwCommonSignPrivacyStatementResult *)modelFromInnerModel:(HLCommonSignPrivacyStatementResult *)signPrivacyStatementResultInner;
@end

NS_ASSUME_NONNULL_END
