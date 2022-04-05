//
//  HwOKCInfo.h
//  HwMobileSDK
//
//  Created by zhangbin on 2019/3/26.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwOKCWhiteInfo : NSObject


/** OKC 设备的mac */
@property (nonatomic,copy) NSString *macAddr;

/** OKC 设备名称 */
@property (nonatomic,copy) NSString *type;

/** success/failed/init/starting */
@property (nonatomic,copy) NSString *status;

/** OKC 设备的Wifi频段 */
@property(nonatomic, copy) NSString *band;

/** OKC 设备的信号强度 */
@property(nonatomic, copy) NSString *rssi;

/** OKC 设备类别 */
@property(nonatomic, copy) NSString *kind;
@end

NS_ASSUME_NONNULL_END
