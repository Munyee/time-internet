//
//  HwApplicationServiceSave.h
//  MobileSDK_Save
//
//  Created by guozheng on 18/7/3.
//  Copyright © 2018年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <HwMobileSDK/HwCallback.h>
#import <HwMobileSDK/HwAppInfo.h>
#import <HwMobileSDK/HwAppDetail.h>
#import <HwMobileSDK/HwCallbackAdapter.h>
#import <HwMobileSDK/HwAppDetail.h>
#import <HwMobileSDK/HwAppImageInfo.h>

@interface HwApplicationServiceSave : NSObject

/**
 *  
 *
 *  @brief 查询应用详情(query application details)
 *
 *  @param appId    应用ID(最长64字节)(application ID (64 bytes at most))
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)queryAppDetail:(NSString *)appId withCallback: (id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询应用列表(query an application list)
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)queryAllAppList:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询应用图标(Query the application icon.)
 *
 *  @param appIdLists appId列表(appId list)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)queryAppImageList:(NSMutableArray *)appIdLists withCallback:(id<HwCallback>)callback;


@end
