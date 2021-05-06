//
//  HwApStbModel.h
//  HwMobileSDK
//
//  Created by ios on 2020/8/31.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwApStbModel : NSObject

/// apMac
@property (nonatomic, copy) NSString *apMac;

/// stbList lanx，如@[@"lan3",@"lan2"]
@property (nonatomic, strong) NSArray<NSString *> *stbPortList;

@end

NS_ASSUME_NONNULL_END
