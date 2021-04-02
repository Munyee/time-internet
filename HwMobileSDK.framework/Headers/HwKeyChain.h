//
//  HwKeyChain.h
//  HwMobileSDK
//
//  Created by ios on 2019/4/11.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwKeyChain : NSObject


/**
 保存数据

 @param data 数据值
 @param key 键
 @return 是否保存成功
 */
+ (BOOL)saveData:(id)data withKey:(NSString *)key;

/**
 读取数据

 @param key 键
 @return 读取到的数据
 */
+ (id)loadDataWithKey:(NSString *)key;

/**
 删除数据

 @param key 键
 @return 是否删除成功
 */
+ (BOOL)removeDataWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
