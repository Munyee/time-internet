//
//  HwFunctionSDKApp.h
//  FunctionSDK
//  Version 0.0.0.1

//  Copyright © 2016年 Huawei. All rights reserved.
//

#ifndef HwFunctionSDKApp_h
#define HwFunctionSDKApp_h

#import <FunctionSDK/HwFunctionSDKActionException.h>
#import <FunctionSDK/HwFunctionSDKCallback.h>
#import <FunctionSDK/HwFunctionCallbackAdapter.h>
#import <FunctionSDK/HwInitFunctionSDKData.h>


/**
 Huawei SDK入口
 */
@interface HwFunctionSDKApp : NSObject

/**
 *
 *  @brief 初始化能力SDK信息
 *
 *  @param (HwInitFunctionSDKData*)initData       NetOpen初始化信息
 *  @param callback       调用返回回调
 *
 *  @since 1.0
 */
+ (void)initWithNetOpenAuth:(HwInitFunctionSDKData*)initData withCallback:(id<HwFunctionSDKCallback>)callback;

@end
#endif /* HwFunctionSDKApp_h */
