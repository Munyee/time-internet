//
//  HwControllerService+Device.h
//  HwMobileSDK
//
//  Created by ios1 on 2019/12/9.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import "HwControllerService.h"

NS_ASSUME_NONNULL_BEGIN

@interface HwControllerService (Device)
#pragma mark 设备 (device)
/**
 *
 *
 *  @brief 查询网关下挂设备列表 (query a list of devices connected to the gateway)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)queryLanDeviceList:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询网关下挂设备列表-扩展接口支持返回离线设备 (query a list of devices connected to the gateway)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)queryLanDeviceListEx:(NSString *)deviceId withCallback:(id<HwCallback>)callback;
/**
 *
 *
 *  @brief 查询网关下挂设备数量 (query the number of devices connected to the gateway)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)queryLanDeviceCount:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 获取下挂设备命名 (obtain a name of a connected device)
 *
 *  @param deviceId         网关ID (gateway ID)
 *  @param lanDeviceMacList 下挂设备MAC地址数组 (array of MAC addresses of connected devices)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getLanDeviceName:(NSString *)deviceId
        lanDeviceMacList:(NSMutableArray *)lanDeviceMacList
            withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询指定下挂设备当前流量(query current traffic of a specified device connected)
 *
 *  @param deviceId         网关ID (gateway ID)
 *  @param lanDeviceMacList 查询设备的mac列表 (query a list of MAC addresses of devices)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getDeviceTraffic:(NSString *)deviceId
       withDeviceMacList:(NSMutableArray *)lanDeviceMacList
            withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 重命名下挂设备(rename a device)
 *
 *  @param deviceId
 *  @param lanDevice 下挂设备信息 (information about a connected device)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)renameLanDevice:(NSString *)deviceId withLanDevice:(HwLanDevice *)lanDevice withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 获取设备限速(下挂设备上下行最大带宽查询) (obtain the device rate limit, or query the maximum uplink and downlink bandwidth of a connected device)
 *
 *  @param deviceId  网关ID (gateway ID)
 *  @param lanDevice 下挂设备 (a connected device)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getLanDeviceBandWidthLimit:(NSString *)deviceId
                     withLanDevice:(HwLanDevice *)lanDevice
                      withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置下挂设备限速(下挂设备上下行最大带宽配置)(obtain the rate limit of a connected device, or query the maximum uplink and downlink bandwidth settings of a connected device)
 *
 *  @param deviceId           网关ID (gateway ID)
 *  @param lanDeviceBandWidth 下挂设备带宽 (bandwidth of a connected device)
 *  @param callback           返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)setLanDeviceBandWidthLimit:(NSString*)deviceId
            withLanDeviceBandWidth:(HwLanDeviceBandWidth*)lanDeviceBandWidth
                      withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询LED状态 (query the LED status)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getLedStatus:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置LED状态 (set the LED status)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)setLedStatus:(NSString *)deviceId withLedInfo:(HwLedInfo *)ledInfo withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询疑似蹭网设备列表
 *
 *  @param deviceId 网关id (id of gateway)
 *  @param callback
 *
 *  @since 1.0
 */
-(void)querySuspectedRubbingLanDeviceList:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 查询网关下挂设备的制造信息接口
 @param deviceId 网关mac
 @param macList 需要查询的下挂设备
 @param callback 回调
 @since 1.2.5(NCE)
 */
-(void)queryLanDeviceManufacturingInfoList:(NSString *)deviceId
                                   macList:(NSArray <NSString *>*)macList
                                  callback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 获取黑名单列表 (obtain a blacklist)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getLanDeviceBlackList:(NSString *)deviceId withCallback:(id<HwCallback>)callback;


/**
 *
 *
 *  @brief 添加设备到黑名单列表 (add a device to the blacklist)
 *
 *  @param param    请求参数 (request parameters)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)addLanDeviceToBlackList:(NSString *)deviceId
                  withLanDevice:(HwLanDevice *)lanDevice
                   withCallback:(id<HwCallback>)callback;

/**
 批量设置黑名单
 
 @param deviceId 网关ID
 @param list 设备列表 (request parameters)
 @param isAdd YES加入黑名单   NO移除黑名单
 @param callback
 */
- (void)setLanDeviceToBlackList:(NSString *)deviceId
                       withList:(NSArray <HwLanDevice *>*)list
                          isAdd:(BOOL)isAdd
                   withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 从黑名单列表中删除设备 (delete a device from the blacklist)
 *
 *  @param param    请求参数 (request parameters)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)deleteLanDeviceFromBlackList:(NSString *)deviceId
                       withLanDevice:(HwLanDevice *)lanDevice
                        withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 批量删除离线设备
 *
 *  @param param    请求参数 (request parameters)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)removeOfflineDevList:(NSString *)deviceId
               withLanDevice:(NSArray <HwLanDevice *>*)lanList
                withCallback:(id<HwCallback>)callback;
#pragma mark AP
/**
 *
 *
 *  @brief 得到AP信息
 *  @param deviceId 网关id (id of gateway)
 *  @param apMac
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getApWifiInfo:(NSString *)deviceId apMac:(NSString *)apMac withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询拓扑AP信息(Query the AP information.)
 *
 *  @param deviceId 网关的设备ID(gateway device ID)
 *  @param callback callback
 *
 *  @since 1.7
 */
- (void)getWirelessAccessPointList:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 获取周边wifi
 *
 *  @param deviceId 网关id (id of gateway)
 *  @param HwApChannelInfo 查询参数 (query Param)
 *  @param callback
 *
 *  @since 1.0
 */
-(void)getApWlanNeighborInfo:(NSString *)deviceId
               withApChannel:(HwApChannelInfo *)apChannelInfo
                withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询指定AP信息(Query the AP information.)
 *
 *  @param deviceId 网关的设备ID(gateway device ID)
 *  @param callback callback
 *
 *  @since 3.0
 */
- (void)getSpecifiedAPList:(NSString *)deviceId
             withApMacList:(NSArray *)apMacList
              withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置同步WiFi开关到外置AP(Configure to synchronize Wi-Fi switch setting to an external AP.)
 *
 *  @param deviceId     网关的设备ID(gateway device ID)
 *  @param wifiSyncInfo 同步WiFi开关到外置AP配置信息(Configuration for synchronizing Wi-Fi switch setting to an external AP)
 *  @param callback     回调(callback)
 *
 *  @since 1.6
 */
- (void)setSyncWifiSwitchToAp:(NSString *)deviceId
       withSyncWifiSwitchInfo:(HwSyncWifiSwitchInfo *)wifiSyncInfo
                 withCallback:(id<HwCallback>)callback;


/**
 *
 *
 *  @brief 查询AP的WIFI路况信息(Query Wi-Fi route conditions of the AP.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param macStr   MAC地址(MAC address)
 *  @param callback 返回的回调(returned callback)
 *
 *  @since 1.0
 */
- (void)getApTrafficInfo:(NSString *)deviceId
               withApMac:(NSString *)macStr
            withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 触发AP自动调整到最优工作信道(Trigger the AP to automatically switch to the optimal working channel.)
 *
 *  @param deviceId  网关ID(gateway ID)
 *  @param apChannel 信道信息类(channel information type)
 *  @param callback  返回的回调(returned callback)
 *
 *  @since 1.6.0
 */
- (void)setApChannelAuto:(NSString *)deviceId
       withApChannelInfo:(HwApChannelInfo *)apChannel
            withCallback:(id<HwCallback>)callback;

/**
 重启AP
 
 @param deviceId 网关ID(gateway ID)
 @param apMac    AP的ID(AP ID)
 @param callback 返回的回调(return callback)
 */
- (void)rebootAp:(NSString *)deviceId withApMac:(NSString *)apMac withCallback:(id<HwCallback>)callback;
/**
 *
 *
 *  @brief 查询AP是否需要升级 ()
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param isApNeededUpgradeParam 判断AP升级参数类
 *  @param callback
 *
 *  @since 1.0
 */
-(void)isApNeededUpgrade:(NSString *)deviceId withIsApNeededUpgradeParam:(HwIsApDeviceNeededUpgradeParam *)isApNeededUpgradeParam
            withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 升级AP ()
 *
 *  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
 *  @param apUpgradeParam AP升级参数类
 *  @param callback
 *
 *  @since 1.0
 */
-(void)apUpgrade:(NSString *)deviceId withApUpgradeParam:(HwApDeviceUpgradeParam *)apUpgradeParam
    withCallback:(id<HwCallback>)callback;

/**
*
*
*  @brief 获取下行PON口的下挂Edge ONT信息
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param portIndexArray PON端口序号数组
*  @param callback  NSArray<HwLanEdgeOntInfo *>
*
*  @since 1.0
*/
-(void)getLanEdgeOntInfo:(NSString *)deviceId withPortIndexArray:(NSArray *)portIndexArray withCallback:(id<HwCallback>)callback;

/**
*
*  @brief 获取网关一网多用端口
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param callback HwPortProperty
*
*/
- (void)getPortProperty:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
*
*  @brief 设置网关一网多用端口
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param param 入参数据模型
*  @param callback HwResult
*
*/
- (void)setPortProperty:(NSString *)deviceId param:(HwPortProperty *)param withCallback:(id<HwCallback>)callback;

/**
*
*  @brief 设置ap指定端口接STB
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param param 入参数据模型数组
*  @param callback HwResult
*
*/
- (void)setApStbPort:(NSString *)deviceId param:(NSArray <HwApStbModel *>*)param withCallback:(id<HwCallback>)callback;

/**
*
*  @brief 获取所有下挂ap的STB信息
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param callback NSArray<HwApStbModel *>
*
*/
- (void)getAllApStbPort:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
*
*  @brief 获取可接STB的ap信息
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param callback NSArray<HwApStbModel *>
*
*/
- (void)getValidApStbPort:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
*
*  @brief 获取网关的lan口信息
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param callback NSArray<HwLanInfo *>
*
*/
- (void)getGatewayLanInfo:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
*
*  @brief 获取AP的lan口信息
*
*  @param deviceId 要操作的网关ID (ID of the gateway to be operated)
*  @param callback NSArray<HwApLanInfo *>
*
*/
- (void)getApLanInfo:(NSString *)deviceId withCallback:(id<HwCallback>)callback;
@end

NS_ASSUME_NONNULL_END
