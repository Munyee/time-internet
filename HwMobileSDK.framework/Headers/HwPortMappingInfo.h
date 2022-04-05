//
//  HwPortMappingInfo.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/10.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HwPortMapping;
@class HLPortMappingInfo;
@interface HwPortMappingInfo : NSObject
/** WAN连接名称，规则：序号_关键字_桥接或路由方式_VLAN信息 */
@property (nonatomic , copy) NSString *wanName;
/** port mapping 数组 */
@property (nonatomic , strong) NSMutableArray<HwPortMapping *> *portMappingList;

/**
 controllerService.getPortMappingInfo 返回数据
 */
- (NSMutableArray<HwPortMappingInfo *> *) listWithHLList:(NSMutableArray<HLPortMappingInfo *> *)hlPortMappingList;
@end

@interface HwPortMapping : NSObject
/** 端口映射序号 */
@property (nonatomic , assign) NSInteger portMappingIndex;
/** 启用开关。TRUE 表示启用，FALSE 表示禁用 */
@property (nonatomic , assign) NSInteger enable;
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
