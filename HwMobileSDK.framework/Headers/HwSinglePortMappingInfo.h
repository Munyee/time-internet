//
//  HwSinglePortMappingInfo.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/10.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwSinglePortMappingInfo : NSObject

/** WAN名称 */
@property (nonatomic , copy) NSString *wanName;
/** 外部监听端口，取值范围[0-65535] */
@property (nonatomic , assign) NSInteger externalPort;
/** 网关需要将连接请求转发到内部主机的端口，取值[0-65535] */
@property (nonatomic , assign) NSInteger internalPort;
/** 端口映射的协议，如下值之一：TCP | UDP | TCP/UDP */
@property (nonatomic , copy) NSString *portMappingProtocol;
/** 内部主机 IP */
@property (nonatomic , copy) NSString *internalClient;


@end

NS_ASSUME_NONNULL_END
