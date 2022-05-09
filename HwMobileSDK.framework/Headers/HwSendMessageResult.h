//
//  HwSendMessageResult.h
//  MobileSDK
//
//  Created by guozheng on 2017/6/15.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <HwMobileSDK/HwResult.h>

@interface HwSendMessageResult : HwResult

/** 消息ID */
@property (nonatomic, assign) UInt64 msgId;
/** 消息时间 */
@property (nonatomic, assign) UInt64 msgTime;

/** 消息流水号，每个家庭的每种消息类型内唯一*/
@property (nonatomic, assign) long messageSn;

@end
