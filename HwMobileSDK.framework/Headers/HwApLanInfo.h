//
//  HwApLanInfo.h
//  HwMobileSDK
//
//  Created by ios on 2020/9/15.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwApLanInfo : NSObject

/** AP MAC地址 */
@property(nonatomic,copy) NSString *mac;

/** LAN口数量 */
@property(nonatomic,assign) int portNumber;

@end

NS_ASSUME_NONNULL_END
