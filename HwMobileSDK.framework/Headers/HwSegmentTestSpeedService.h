//
//  HwSegmentTestSpeedService.h
//  HwMobileSDK
//
//  Created by wuwenhao on 2019/4/17.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwCallback.h>
#import <HwMobileSDK/HwCallbackAdapter.h>
#import <HwMobileSDK/HwStartSegmentSpeedTestParam.h>
#import <HwMobileSDK/HwStartSegmentSpeedTestResult.h>
#import <HwMobileSDK/HwGetSegmentSpeedResultParam.h>
#import <HwMobileSDK/HwGetSegmentSpeedResult.h>
#import <HwMobileSDK/HwStopSegmentSpeedTestParam.h>
#import <HwMobileSDK/HwStopSegmentSpeedTestResult.h>
#import <HwMobileSDK/HwSpeedTestConfigInfo.h>
#import <HwMobileSDK/HwSegmentTestGetHistoryRecordParam.h>
#import <HwMobileSDK/HwSegmentTestSpeedRecordInfo.h>
#import <HwMobileSDK/HwSegmentTestSaveRecordParam.h>
#import <HwMobileSDK/HwSegmentTestSaveRecordResult.h>
#import <HwMobileSDK/HwSegmentSpeedResult.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwSegmentTestSpeedService : NSObject

/**
 开启分段测速

 @param deviceId 设备 id
 @param testItems 开启参数对象
 @param callback 回调 | (HwStartSegmentSpeedTestResult *)value
 */
- (void) startSegmentSpeedTestWithDeviceId:(NSString *)deviceId
                                     param:(NSArray<HwStartSegmentSpeedTestParam *> *)testItems
                                  callback:(id<HwCallback>)callback;

/**
 查询分段测试状态结果

 @param deviceId 设备 id
 @param param 查询参数对象
 @param callback 回调 | (NSArray<HwGetSegmentSpeedResult *> *)value
 */
- (void) getSegmentSpeedTestResultWithDeviceId:(NSString *)deviceId
                                         param:(HwGetSegmentSpeedResultParam *)param
                                      callback:(id<HwCallback>)callback;
/**
 查询分段测试状态结果以及启动状态

 @param deviceId 设备 id
 @param param 查询参数对象
 @param callback 回调 | (NSArray<HwGetSegmentSpeedResult *> *)value
 */
- (void) getSegmentSpeedTestResultAndStatusWithDeviceId:(NSString *)deviceId
                                         param:(HwGetSegmentSpeedResultParam *)param
                                      callback:(id<HwCallback>)callback;

/**
 查询分段测试过程结果
 
 @param deviceId 设备 id
 @param param 查询参数对象
 @param callback 回调 | (NSArray<HwGetSegmentSpeedResult *> *)value
 */
- (void) querySegmentSpeedProcessResult:(NSString *)deviceId
                                  param:(HwQuerySegmentSpeedProcessParam *)param
                               callback:(id<HwCallback>)callback;

/**
 停止分段测试

 @param deviceId 设备 id
 @param param 停止测试参数对象
 @param callback 回调 | (HwStopSegmentSpeedTestResult *)value
 */
- (void) stopSegmentSpeedTestWithDeviceId:(NSString *)deviceId
                                    param:(HwStopSegmentSpeedTestParam *)param
                                 callback:(id<HwCallback>)callback;

/**
 获取平台分段测试配置信息

 @param callback 回调 | (HwSpeedTestConfigInfo *)value
 */
- (void) getSegmentSpeedTestConfigManagementWithCallback:(id<HwCallback>)callback;

/**
 获取分段测试历史记录

 @param param 获取分段测试历史记录参数对象
 @param callback 回调 | (*NSArray<HwSegmentTestSpeedRecordInfo *> *)value
 */
- (void) getSegmentSpeedTestHistoryRecordWithParam:(HwSegmentTestGetHistoryRecordParam *)param
                                          callback:(id<HwCallback>)callback;

/**
 保存分段测试记录

 @param record 待保存的记录对象
 @param callback 回调 | (HwSegmentTestSaveRecordResult *)value
 */
- (void) saveSegmentSpeedTestRecordWithParam:(HwSegmentTestSaveRecordParam *)record
                                    callback:(id<HwCallback>)callback;
@end

NS_ASSUME_NONNULL_END
