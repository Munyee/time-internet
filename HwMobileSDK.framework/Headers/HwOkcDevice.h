//
//  HwOkcDevice.h
//  HwMobileSDK
//
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwOkcDevice : NSObject

/** OKC 设备的MAC地址 (MAC address of the mounted device)*/
@property(nonatomic, copy) NSString *mac;

/** OKC 设备的Wifi频段 */
@property(nonatomic, copy) NSString *band;

/** OKC 设备的信号强度 */
@property(nonatomic, copy) NSString *rssi;

/** OKC 设备类别 */
@property(nonatomic, copy) NSString *kind;

/** OKC 设备类型名称*/
@property(nonatomic, copy) NSString *type;

@end

