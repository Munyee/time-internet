//
//  HwControllerService+ParentControl.h
//  HwMobileSDK
//
//  Created by ios1 on 2019/12/9.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <HwMobileSDK/HwControllerService.h>
#import <HwMobileSDK/HwEaiInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwControllerService (ParentControl)


/**
 *
 *
 *  @brief 获取家长控制模板详细信息 (obtain parental control template details)
 *
 *  @param deviceId
 *  @param templateName
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getAttachParentControlTemplate:(NSString *)deviceId
                      withTemplateName:(NSString *)templateName
                          withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 获取家长控制模板名称列表 (obtain a parental control template list)
 *
 *  @param deviceId
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getAttachParentControlTemplateList:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询家长控制列表 (query parental control list)
 *  查询所有家长控制模板以及模板下面绑定的设备列表
 *  @param deviceId
 *  @param parentControlTemplate
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getParentControlTemplateDetailList:(NSString *)deviceId
                 withParentControlNameList:(NSArray *)nameList
                              withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 删除家长控制模板 (delete a parental control template)
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param templateName
 *  @param callback
 *
 *  @since 1.0
 */
-(void)deleteAttachParentControlTemplate:(NSString *)deviceId
                                withName:(NSString *)templateName
                            withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 批量删除家长控制模板 (delete parental control list)
 *  @param deviceId     网关ID
 *  @param nameList     模板名称数组
 *  @param callback
 *
 *  @since 1.0
 */
- (void)deleteParentControlTemplateList:(NSString *)deviceId
              withParentControlNameList:(NSArray *)nameList
                           withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 添加/覆盖家长控制模板 (add/overwrite a parental control template)
 *
 *  @param deviceId
 *  @param parentControlTemplate
 *  @param callback
 *
 *  @since 1.0
 */
-(void)setAttachParentControlTemplate:(NSString *)deviceId
                    withParentControl:(HwAttachParentControlTemplate *)parentControlTemplate
                         withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置家长控制 (set parental control)
 *
 *  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
 *  @param mac  设备MAC地址 (device MAC address)
 *  @param templateName  控制模板名称 (parental control template name)
 *  @param callback
 *
 *  @since 1.0
 */
-(void)setAttachParentControl:(NSString *)deviceId
      withAttachParentControl:(HwAttachParentControl *)attachParentControl
                 withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 删除家长控制 (remove parental control)
 *
 *  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
 *  @param attachParentControl 家长控制 (parental control)
 *  @param callback
 *
 *  @since 1.0
 */
-(void)deleteAttachParentControl:(NSString *)deviceId
         withAttachParentControl:(HwAttachParentControl *)attachParentControl
                    withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 获取家长控制列表 (obtain a parental control list)
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param callback
 *
 *  @since 1.0
 */
-(void)getAttachParentControlList:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

#pragma mark 新家长控制
/**
*
*
*  @brief 添加设备家长控制
*
*  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
*  @param 设备mac
*  @param callback HwInternetControlConfig
*
*/
- (void)addDeviceToInternetControl:(NSString *)deviceId param:(NSString *)deviceMac withCallback:(id<HwCallback>)callback;

/**
*
*
*  @brief 查询家长控制的设备列表
*
*  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
*  @param callback Array<HwInternetControlBasicConfig>
*
*/
- (void)getInternetControlDeviceList:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
*
*
*  @brief 查询设备家长控制
*
*  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
*  @param 设备mac
*  @param callback HwInternetControlConfig
*
*/
- (void)getInternetControlConfig:(NSString *)deviceId param:(NSString *)deviceMac withCallback:(id<HwCallback>)callback;

/**
*
*
*  @brief 修改设备家长控制
*
*  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
*  @param 配置
*  @param callback HwResult
*
*/
- (void)setInternetControlConfig:(NSString *)deviceId param:(HwInternetControlConfig *)param withCallback:(id<HwCallback>)callback;

/**
*
*
*  @brief  删除设备家长控制
*
*  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
*  @param 设备mac
*  @param callback HwResult
*
*/
- (void)deleteInternetControlConfig:(NSString *)deviceId param:(NSString *)deviceMac withCallback:(id<HwCallback>)callback;

/**
*
*
*  @brief  获取设备时长统计
*
*  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
*  @param 设备mac
*  @param callback HwDeviceOnlineTimeInfo
*
*/
- (void)getDeviceOnlineTimeStatistics:(NSString *)deviceId param:(NSString *)deviceMac withCallback:(id<HwCallback>)callback;

/**
*
*
*  @brief  获取设备流量统计
*
*  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
*  @param 设备mac
*  @param callback HwDeviceTrafficTimeInfo
*
*/
- (void)getDeviceTrafficStatistics:(NSString *)deviceId param:(NSString *)deviceMac withCallback:(id<HwCallback>)callback;

/**
*
*
*  @brief  查询加速生效的STA列表
*
*  @param deviceId  要操作的网关ID (ID of the gateway to be operated)
*  @param callback HwEaiInfo
*
*/
- (void)getEaiInfo:(NSString *)deviceId withCallback:(id<HwCallback>)callback;
@end

NS_ASSUME_NONNULL_END
