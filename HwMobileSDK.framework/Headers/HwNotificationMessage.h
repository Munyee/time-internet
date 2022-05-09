//
//  HwNotificationMessage.h
//  HwMobileSDK
//
//  Created by ios on 2019/3/21.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwNotificationMessage : NSObject
/** 错误码 */
@property (nonatomic, copy)NSString *errorCode;
/** 错误信息 */
@property (nonatomic, copy)NSString *errorMessage;
/** 失效状态：近端true，远端false */
@property (nonatomic, assign)BOOL isLocalInvalid;
@end

NS_ASSUME_NONNULL_END
