//
//  HwSignedRecord.h
//  HwMobileSDK
//
//  Created by zhangbin on 2019/5/15.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwSignedRecord : NSObject

/** 签署的时间 */
@property (nonatomic, copy) NSString *signedTime;
/** 隐私申明的版本号版本 */
@property (nonatomic, copy) NSString *signedVersion;

@end

NS_ASSUME_NONNULL_END
