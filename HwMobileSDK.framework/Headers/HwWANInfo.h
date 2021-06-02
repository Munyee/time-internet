//
//  HwWANInfo.h
//  HwMobileSDK
//

//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwWANInfo : NSObject

/** Index */
@property(nonatomic, assign) int index;

/** IPv4 */
@property(nonatomic, copy) NSString *iPv4Status;

/** IPv6 */
@property(nonatomic, copy) NSString *iPv6Status;

@end

NS_ASSUME_NONNULL_END
