//
//  HwAppImageInfo.h
//  MobileSDK
//
//  Created by huangxiaogang on 16/10/14.
//  Copyright © 2016年 com.huawei. All rights reserved.(Copyright © 2016 HUAWEI. All rights reserved.)
//

#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 图片信息类(picture information)
 *
 *  @since 1.0
 */
@interface HwAppImageInfo : NSObject

/** appID*/
@property (nonatomic, copy) NSString *appId;

/** 应用图标(application icon) */
@property (nonatomic, copy) NSString *imageMd5;

/** 应用图标(application icon) */
@property (nonatomic, copy) UIImage *image;


@end
