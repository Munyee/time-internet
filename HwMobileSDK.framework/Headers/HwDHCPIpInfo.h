//
//  HwDHCPIpInfo.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/10.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HLDHCPIpInfo;
NS_ASSUME_NONNULL_BEGIN

@interface HwDHCPIpInfo : NSObject
@property (nonatomic , copy) NSString *mac;
@property (nonatomic , copy) NSString *ipAddr;

- (NSArray<HwDHCPIpInfo *> *) listWithHLList:(NSArray<HLDHCPIpInfo *> *)hlList;
@end

NS_ASSUME_NONNULL_END
