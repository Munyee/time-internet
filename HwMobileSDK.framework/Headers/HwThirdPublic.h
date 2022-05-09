//
//  HwThirdPublic.h
//  HwMobileSDK
//
//  Created by ios on 2021/10/28.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kHwInternetUnknown = -1,
    kHwInternetNotReachable = 0,
    kHwInternetWWan = 1,
    kHwInternetWiFi = 2,
} HwInternetType;

/// 网络状态变化的通知
FOUNDATION_EXPORT NSString * _Nullable const HwNetworkChangeNotification;

NS_ASSUME_NONNULL_BEGIN

@interface HwThirdPublic : NSObject

/// 解压缩
/// @param path 源文件路径
/// @param destination 目标路径
- (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;

/// 压缩
/// @param path 压缩目标路径
/// @param paths 被压缩文件集合
+ (BOOL)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray<NSString *> *)paths;

/// 压缩
/// @param path 压缩目标路径
/// @param directoryPath 被压缩文件夹
+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath;

/// 开始网络监听
+ (void)startMonitorWifiChange;

/// 停止网络监听
+ (void)stopMonitorWifiChange;

/// 获取当前网络状态
+ (HwInternetType)getInternetStatus;

/// 下载文件
/// @param request 请求体
/// @param downloadProgressBlock 下载进度回调
/// @param destinationBlock 下载路径回调
/// @param completionHandler 下载完成/失败回调
+ (void)downloadRequest:(NSURLRequest *)request
               progress:(void (^)(NSProgress *))downloadProgressBlock
            destination:(NSURL * (^)(NSURL *, NSURLResponse *))destinationBlock
      completionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler;
@end

NS_ASSUME_NONNULL_END
