//
//  HwDeleteParentControlTemplateListResult.h
//  HwMobileSDK
//
//  Created by ios on 2018/12/28.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import "HwResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface HwDeleteParentControlTemplateListResult : HwResult


/**
 删除成功的name数组
 */
@property (nonatomic,strong) NSArray *successList;

@end

NS_ASSUME_NONNULL_END
