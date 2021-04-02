//
//  HLIpPingDiagnosticsResult.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/7.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 测试状态 
- HwPingDiagnosticsStatusComplete: 成功（成功时其它数据才有意义） 
- HwPingDiagnosticsStatusUnreach: 失败 
- HwPingDiagnosticsStatusRequest: 诊断未完成 */
typedef NS_ENUM(NSInteger, HwPingDiagnosticsStatus) {    
HwPingDiagnosticsStatusComplete = 0,   
HwPingDiagnosticsStatusUnreach,    
HwPingDiagnosticsStatusRequest,
};

NS_ASSUME_NONNULL_BEGIN

@interface HwIpPingDiagnosticsResult : NSObject

@property (nonatomic , assign) HwPingDiagnosticsStatus pingStatus;
/** 测试过程中 ping 包平均返回时延，单位 ms */
@property (nonatomic , assign) NSInteger averageResponseTime;
/** 测试过程中 ping 包最小返回时延，单位 ms */
@property (nonatomic , assign) NSInteger minResponseTime;
/** 测试过程中 ping 包最大返回时延，单位 ms */
@property (nonatomic , assign) NSInteger maxResponseTime;
/** 测试过程中 ping 包成功个数 */
@property (nonatomic , assign) NSInteger successCount;
/** 测试过程中 ping 包失败个数 */
@property (nonatomic , assign) NSInteger failureCount;

@end

NS_ASSUME_NONNULL_END