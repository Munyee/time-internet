//
//  HwControllerService+Wifi.h
//  HwMobileSDK
//
//  Created by ios1 on 2019/12/9.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <HwMobileSDK/HwControllerService.h>
#import <HwMobileSDK/HwSteeringSensitivity.h>
#import <HwMobileSDK/HwScenarioConfig.h>
#import <HwMobileSDK/HwRadioOptimize.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwControllerService (Wifi)

#pragma mark WIFI

/**
 *
 *
 *  @brief 查询WIFI信息(query Wi-Fi information)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param ssidIndex ssid序号(SSID sequence number)
 *  @param callback  回调(callback)
 *
 *  @since 1.0
 */
- (void)getWifiInfo:(NSString *)deviceId withSsidIndex:(int)ssidIndex withCallback:(id<HwCallback>)callback;

/**
 查询所有WiFi信息
 
 @param deviceId 网关ID(gateway ID)
 @param callback 回调(callback)
 */
- (void)getWifiInfoAll:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 查询所有WiFi信息
 
 @param deviceId 网关ID(gateway ID)
 @param callback 回调(callback)
 */
- (void)getWifiInfoAllWithoutLogin:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置WIFI配置(set Wi-Fi configurations)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param wifiInfo 网关模型(Gateway model)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)setWifiInfo:(NSString *)deviceId
      withSsidIndex:(int)ssidIndex
       withWifiInfo:(HwWifiInfo *)wifiInfo
       withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置WIFI配置(set Wi-Fi configurations)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param wifiInfo 网关模型(Gateway model)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)setWifiInfoWithoutLogin:(NSString *)deviceId
                  withSsidIndex:(int)ssidIndex
                   withWifiInfo:(HwWifiInfo *)wifiInfo
                   withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 批量配置WIFI(set Wi-Fi configurations)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param wifiInfo wifi模型(wifi model),需指定对应的ssidIndex
 *  @param callback
 *
 *  @since 1.0
 */
- (void)setWifiInfoList:(NSString *)deviceId
          withWifiInfos:(NSArray *)wifiInfoList
           withCallback:(id<HwCallback>)callback;

/**
 添加网关WIFI
 
 @param deviceId 网关ID(gateway ID)
 @param wifiInfo wifiInfo
 @param callback 回调(callback)
 */
- (void)addWlanSsid:(NSString *)deviceId param:(HwWifiInfo *)wifiInfo withCallback:(id<HwCallback>)callback;

/**
 删除网关WIFI
 
 @param deviceId 网关ID(gateway ID)
 @param ssid ssidIndex
 @param callback 回调(callback)
 */
- (void)delWlanSsid:(NSString *)deviceId ssid:(int)ssid withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置WIFI开启(enable Wi-Fi)
 *
 *  @param deviceId   网关ID (gateway ID)
 *  @param ssidIndex  ssid序号(SSID sequence number)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)enableWifi:(NSString*)deviceid withSsidindex:(int)ssidIndex withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置WIFI关闭(disable Wi-Fi)
 *
 *  @param deviceId   网关ID (gateway ID)
 *  @param ssidIndex  ssid序号(SSID sequence number)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)disableWifi:(NSString*)deviceid withSsidindex:(int)ssidIndex withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置定时WIFI (set scheduled Wi-Fi)
 *
 *  @param deviceId  网关ID (gateway ID)
 *  @param wifiTimer WIFI定时信息 (Wi-Fi timing information)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)setWifiTimer:(NSString *)deviceId
       withWifiTimer:(HwWifiTimer *)wifiTimer
        withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询定时WIFI设置 (query scheduled Wi-Fi settings)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param enable
 *  @param startTime 开始时间(start time)
 *  @param endTime 结束时间(end time)
 *  @param KDay 循环周期 (cycle)
 *  @param callback  回调(callback)
 *
 *  @since 1.0
 */
- (void)getWifiTimer:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置WIFI信号强度 (set Wi-Fi signal strength)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param powerLevel WIFI强度 (Wi-Fi strength)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)setWifiTransmitPowerLevel:(NSString*)deviceId
                   withPowerLevel:(HwWifiTransmitPowerLevelInfo *)powerLevel
                     withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询WIFI信号强度 (query Wi-Fi signal strength)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  回调(callback)
 *
 *  @since 1.0
 */
- (void)getWifiTransmitPowerLevel:(NSString*)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 得到WIFI状态 (obtain Wi-Fi status)
 *
 *  @param deviceId  网关ID (gateway ID)
 *  @param ssidIndex ssid序号 (SSID sequence number)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getWifiStatus:(NSString *)deviceId
        withSsidIndex:(int)ssidIndex
         withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询WIFI隐藏开关状态
 *
 *  @param deviceId           网关ID
 *  @param ssidIndex          WIFI index
 *  @param callback           返回回调
 *
 *  @since 1.0
 */
- (void)getWifiHideStatus:(NSString*)deviceId
            withSsidIndex:(int)ssidIndex
             withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置WIFI隐藏开关状态
 *   NCE仅支持消费者,装维不支持 
 *  @param deviceId 网关ID (gateway ID)
 *  @param wifiHideInfo  WiFi隐藏设置信息(wifi hide info)
 *  @param callback  回调(callback)
 *
 *  @since 1.0
 */
-(void)setWifiHideStatus:(NSString *)deviceId
        withWifiHideInfo:(HwWifiHideInfo *)wifiHideInfo
            withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置WiFi频段开关
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param radioType WiFi频段 (2.4G和5G)
 *  @param enableState 频段是否可用(true或者false)
 *  @param callback  回调(callback)
 *
 *  @since 1.2.5(NCE)
 */
-(void)setWifiHardwareSwitch:(NSString *)deviceId
               withRadioType:(NSString *)radioType
             withEnableState:(BOOL)enableState
                withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询访客网络 (query a guest network)
 *
 *  @param deviceId  网关ID (gateway ID)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getGuestWifiInfo:(NSString *)deviceId withCallback:(id<HwCallback>)callback;


/**
 
 @brief 查询访客网络Wi-Fi扩展 (query a guest network)
 @param deviceId 网关ID (gateway ID)
 @param param    参数对象
 @param callback 回调
 */
- (void)getGuestWifiInfo:(NSString *)deviceId
  withGuestWifiInfoParam:(HwGuestWifiInfoParam *)param
            withCallback:(id<HwCallback>)callback;


/**
 *
 *
 *  @brief 设置访客网络 (set a guest network)
 *
 *  @param deviceId      网关ID (gateway ID)
 *  @param guestWifiInfo 访客网络信息 (guest network information)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)setGuestWifiInfo:(NSString *)deviceId
       withGuestWifiInfo:(HwGuestWifiInfo *)guestWifiInfo
            withCallback:(id<HwCallback>)callback;



/**
 *
 *
 *  @brief 查询WIFI下挂设备列表(Query the list of mounted devices.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param callback 返回回调(returned callback)
 *
 *  @since 1.6.0
 */
- (void)queryWifiDeviceList:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

- (void)getWifiAdvInfo:(NSString *)deviceId withWifiAdvancedInfo:(HwWifiAdvancedInfo *)wifiAdvancedInfo withCallback:(id<HwCallback>)callback;

#pragma mark WPS (WPS)
/**
 *
 *
 *  @brief 开启wifi WPS (enable wifi WPS)
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param ssidIndex  ssid序号(SSID sequence number)
 *  @param callback
 *
 *  @since 1.0
 */
-(void)enableWifiwps:(NSString *)deviceId
       withSsinIndex:(int)ssidIndex
        withCallback:(id<HwCallback>)callback;
/**
*
*
*  @brief 关闭wifi WPS
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param ssidIndex  ssid序号(SSID sequence number)
*  @param callback
*
*  @since 1.0
*/
-(void)disableWifiWps:(NSString *)deviceId
withSsinIndex:(int)ssidIndex
 withCallback:(id<HwCallback>)callback;
/**
*
*
*  @brief 查询wifi WPS 配置
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param ssidIndex  ssid序号(SSID sequence number)
*  @param callback
*
*  @since 1.0
*/
-(void)getWifiWpsStatus:(NSString *)deviceId
withSsinIndex:(int)ssidIndex
 withCallback:(id<HwCallback>)callback;

#pragma mark SteeringSensitivity
/**
 *
 *  @brief 设置Wi-Fi漫游灵敏度
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param param  灵敏度
 *  @param callback
 *
 */
- (void)setSteeringSensitivity:(NSString *)deviceId withParam:(HwSteeringSensitivity *)param withCallback:(id<HwCallback>)callback;

/**
 *
 *  @brief 查询Wi-Fi漫游灵敏度
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param callback HwSteeringSensitivity
 *
 */
- (void)querySteeringSensitivity:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

#pragma mark WiFi信道与功率调优
/**
 *
 *  @brief 设置调优场景
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param param  场景
 *  @param callback
 *
 */
- (void)setRadioOptimize:(NSString *)deviceId withParam:(HwScenarioConfig *)param withCallback:(id<HwCallback>)callback;

/**
 *
 *  @brief 查询当前配置场景
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param callback HwScenarioConfig
 *
 */
- (void)queryRadioOptimize:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *  @brief 查询信道和功率调优结果
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param callback HwRadioOptimize
 *
 */
- (void)queryRadioOptimizeResult:(NSString *)deviceId withCallback:(id<HwCallback>)callback;
@end

NS_ASSUME_NONNULL_END
