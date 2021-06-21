//
//  HwSendMessageToOMUserData.h
//  MobileSDK
//
//  Created by guozheng on 17/12/28.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "HLSendMessageToOMUserData.h"
//@class HLSendMessageToOMUserData;

typedef NS_ENUM(NSInteger , HwOMUserAccountType) {
    HwOMUserAccountTypeConsumer,
    HwOMUserAccountTypeOmuser
};

@interface HwSendMessageToOMUserData : NSObject

/** 目的帐号类型 */
@property (nonatomic , assign) HwOMUserAccountType destAccountType;
/** 目的账号 */
@property (nonatomic , copy) NSString *msgDest;
/** 聊天内容 */
@property (nonatomic , copy) NSString *chatInfo;
/** 扩展参数 */
@property (nonatomic , strong) NSDictionary *params;

//- (id) initWithHLModel:(HLSendMessageToOMUserData *)hlModel;

@end
