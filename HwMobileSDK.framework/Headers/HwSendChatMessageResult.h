//
//  HwSendChatMessageResult.h
//  MobileSDK
//
//  Created by guozheng on 18/1/4.
//  Copyright © 2018年 com.huawei. All rights reserved.
//

#import "HwResult.h"

@interface HwSendChatMessageResult : HwResult

@property (nonatomic , copy) NSString *msgId;
@property (nonatomic , copy) NSString *msgTime;
@property (nonatomic , copy) NSString *sn;

@end
