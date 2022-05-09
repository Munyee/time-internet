//
//  HwPortMappingSwitchInfo.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/10.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwPortMappingSwitchInfo : NSObject

/** WAN名称 */
@property (nonatomic , copy) NSString *wanName;
/** 端口映射表项序号 */
@property (nonatomic , assign) NSInteger portMappingIndex;
/** 开关状态 */
@property (nonatomic , assign) BOOL enable;

@end

NS_ASSUME_NONNULL_END
