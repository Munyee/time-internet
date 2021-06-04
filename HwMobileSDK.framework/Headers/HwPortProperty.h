//
//  HwPortProperty.h
//  HwMobileSDK
//
//  Created by ios on 2020/8/28.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface HwPortProperty : NSObject

/// 作为iptv的wan的lan口，取值lanx，如@"lan1"
@property (nonatomic, copy) NSString *iptvUpPort;

///多业务口的集合 lanx+ssidx+ponx，如@[@"lan3",@"ssid2",@"pon1"]
@property (nonatomic, strong) NSArray <NSString *>*mutiServicePort;

@end

NS_ASSUME_NONNULL_END
