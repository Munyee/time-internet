//
//  HLIpPingDiagnosticsInfo.h
//  HwMobileSDK
//
//  Created by wuwenhao on 2018/12/7.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwIpPingDiagnosticsInfo : NSObject
/** WAN 序列 */
@property (nonatomic , copy) NSString *wanName;
/** Ping 测试的主机名或者主机地址 */
@property (nonatomic , copy) NSString *host;
/** 测试过程 Ping 包个数，默认 4  */
@property (nonatomic , assign) NSInteger numberOfRepetitions;
/** 测试过程 Ping 包返回时延限制，单位: ms，默认 10000 */
@property (nonatomic , assign) NSInteger timeout;
/** 每个 Ping 包发送的数据块大小，单位：字节，默认 56 */
@property (nonatomic , assign) NSInteger dataBlockSize;
/** 用来测试包的 DSCP 的值，默认 0 */
@property (nonatomic , assign) NSInteger dscp;

@end

NS_ASSUME_NONNULL_END