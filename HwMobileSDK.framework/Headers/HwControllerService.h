#import <Foundation/Foundation.h>

#import "HwCallback.h"
#import "HwWifiInfo.h"
#import "HwAttachParentControlTemplate.h"
#import "HwLanDeviceBandWidth.h"
#import "HwWifiTimer.h"

#import "HwCommonDefine.h"
@class HwIsApDeviceNeededUpgradeParam;
@class HwApDeviceUpgradeParam;
@class HwApDeviceUpgradeStatusParam;
@class HwCheckGatewayPasswordParam;
@class HwAddLanDeviceToBlackListParam;
@class HwDeleteLanDeviceFromBlackListParam;
@class HwQueryLanDeviceListParam;
@class HwQueryLanDeviceCountParam;
@class HwRenameLanDeviceParam;
@class HwGetLanDeviceNameParam;
@class HwGetLanDeviceBandWidthLimitParam;
@class HwSetLanDeviceBandWidthLimitParam;
@class HwModifyGatewayPasswordParam;
@class HwAttachParentControl;
@class HwLanDevice;
@class HwOKCWhiteInfo;
@class HwGuestWifiInfo;
@class HwWifiTransmitPowerLevelInfo;
@class HwSpeedupStateInfo;
@class HwLoginGatewayParam;
@class HwPPPoEAccount;
@class HwWifiHideInfo;
@class HwGuestWifiInfoParam;

@class HwLedInfo;
@class HwApChannelInfo;

@class HwSyncWifiSwitchInfo;
@class HwWifiAdvancedInfo;
@class HwOfflineNotification;
@class HwOfflineNotificationOption;
@class HwSetGatewayAcsStartParam;

@class HwIpPingDiagnosticsInfo;
@class HwSinglePortMappingInfo;
@class HwPortMappingSwitchInfo;
@class HwDHCPIpInfo;
@class HwGetHomeNetworkTrafficInfoListConfig;

@class HwGetWlanHardwareSwitchParam;
@class HwSetWlanHardwareSwitchParam;
@class HwGetWlanRadioInfoParam;
@class HwSetWlanRadioInfoParam;
@class HwSetGatewayConfigStatusParam;
@class HwSetInternetWanInfoParam;
@class HwSetWebUserPasswordParam;
@class HwWebPwdAndWifiInfo;
@class HwPortProperty;
@class HwApStbModel;
@class HwLanInfo;
@class HwApLanInfo;
@class HwInternetControlConfig;

/**
 网关能力開放接口(Gateway capability open-up interface)
 */
@interface HwControllerService : NSObject

/**
 拨号模式(Dialing mode)
 */
typedef enum
{
    kHwDialOndemand = 1,  // 按需拨号(Dial-on-demand)
    kHwDialAlwayson,  // 自动拨号(Automatic dialing)
    kHwDialManual   // 手动拨号(Manual dialing)
} HwDialMode;

/**
 WAN拨号状态 (WAN dialing status)
 */
typedef enum
{
    kHwWANStatusUnconfigured,
    kHwWANStatusConnecting,
    kHwWANStatusAuthenticating,
    kHwWANStatusConnected,
    kHwWANStatusPendingDisconnect,
    kHwWANStatusDisconneting,
    kHwWANStatusDisconnected
} HwWANStatus;

/**
 拨号失败原因 (Dialing failure cause)
 */
typedef enum
{
    kHwDialReasonErrorNone,   // 无错误(No error)
    kHwDialReasonErrorIspTimeOut, // ISP超时(ISP timeout)
    kHwDialReasonErrorCommandAborted, // 拨号退出(Dialing exit)
    kHwDialReasonErrorNotEnabledForInternet,  // 未启用INTERNET (Internet not enabled)
    kHwDialReasonErrorBadPhoneNumber, // 电话号码错误(Incorrect phone number)
    kHwDialReasonErrorUserDisconnect, // 用户断开连接(User disconnected)
    kHwDialReasonErrorIspDisconnecteisp,  // 中断连接(Disconnected)
    kHwDialReasonErrorIdleDisconnect,     // 空闲断开连接(Idle disconnection)
    kHwDialReasonErrorForcedDisconnect,   // 强制断开连接(Forcible disconnection)
    kHwDialReasonErrorServerOutOfRes,     // 服务器资源耗尽(Server resource exhausted)
    kHwDialReasonErrorRestrictedLogonHours ,// 限制登录期内(Login restriction period)
    kHwDialReasonErrorAccountDisabled ,   // 账户被停用(Account suspended)
    kHwDialReasonErrorAccountExpired ,    // 账户过期(Account expired)
    kHwDialReasonErrorPasswordExpired,    // 密码过期(Password expired)
    kHwDialReasonErrorAuthenticationFaulure,  // 鉴权失败(Authentication failed)
    kHwDialReasonErrorNoDialtoned,    // 没有拨号音(No dialing tone)
    kHwDialReasonErrorNoCarrier,      // 没有载波(No carrier)
    kHwDialReasonErrorNoAnswer,       // 没有应答(No answer)
    kHwDialReasonErrorLineBusy,       // 线路忙 (Line busy)
    kHwDialReasonErrorUnsupportedBitspersecond,   // 速率不支持 (Rate unsupported)
    kHwDialReasonErrorTooManyLineErrors,  // 线路错误过多(Too many line errors)
    kHwDialReasonErrorIpConfigurationip,  // 配置错误(Incorrect configurations)
    kHwDialReasonErrorUnknow,    // 未知错误(Unknown error)
    kHwDialReasonErrorNoValidConnection   // 无有效的PPP连接(No valid PPP connection)
} HwDialReason;


typedef enum
{
    kHwCloudStatusNotConnect = 0,   // 未连接(Not connected)
    kHwCloudStatusConnecting,   // 正在尝试连接(Attempting to connect...)
    kHwCloudStatusRegisting,    // 注册中(Registering...)
    kHwCloudStatusHeartbeating, // 心跳保持中(Heartbeat keeping..)
    kHwCloudStatusHeartbeated,  // 等待下次心跳中(Waiting for the next heartbeat...)
    kHwCloudStatusRegisterError, // 注册失败(Registration failed)
} HwCloudStatus;

#pragma mark AP



/**
 设置（覆盖）OKC设备到白名单
 
 @param deviceId 网关ID
 @param list 设备列表 (request parameters)
 @param callback
 */
- (void) setOKCWhiteList:(NSString *)deviceId
                withList:(NSArray <HwOKCWhiteInfo *>*)list
            withCallback:(id<HwCallback>)callback;
/**
 添加白名单
 
 @param deviceId 网关ID
 @param list 设备列表 (request parameters)
 @param callback
 */
- (void) addOKCWhiteList:(NSString *)deviceId
                withList:(NSArray <HwOKCWhiteInfo *>*)list
            withCallback:(id<HwCallback>)callback;
/**
 查询白名单
 
 @param deviceId 网关ID
 @param callback
 */
- (void) getOKCWhiteList:(NSString *)deviceId
            withCallback:(id<HwCallback>)callback;
/**
 删除白名单
 
 @param deviceId 网关ID
 @param list 设备列表 (request parameters)
 @param callback
 */
- (void) deleteOKCWhiteList:(NSString *)deviceId
                   withList:(NSArray <NSString *>*)list
               withCallback:(id<HwCallback>)callback;

/**
 查询OKC设备列表

 @param deviceId 网关ID
 @param callback 回调
 */
- (void)getLanDeviceOKCList:(NSString *)deviceId
               withCallback:(id<HwCallback>)callback;

/**
 *  @author Huawei
 *
 *  @brief 查询设备WLAN频段开关
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param param 参数
 *  @param callback 回调(NSArray<HwWlanHardwareSwitchInfo *>)
 *
 *  @since 1.0
 */

- (void)getWlanHardwareSwitch:(NSString *)deviceId
                        param:(HwGetWlanHardwareSwitchParam *)param
                 withCallback:(id<HwCallback>)callback;

/**
 *  @author Huawei
 *
 *  @brief 设置设备WLAN频段开关
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param param 参数
 *  @param callback 回调(HwSetWlanHardwareSwitchResult)
 *
 *  @since 1.0
 */

- (void)setWlanHardwareSwitch:(NSString *)deviceId
                        param:(HwSetWlanHardwareSwitchParam *)param
                 withCallback:(id<HwCallback>)callback;

/**
 查询设备WLAN频段信息

 @param deviceId 网关mac
 @param param 参数
 @param callback 回调
 */
- (void)getWlanRadioInfo:(NSString *)deviceId
                   param:(HwGetWlanRadioInfoParam *)param
            withCallback:(id<HwCallback>)callback;

/**
 设置设备WLAN频段信息
 
 @param deviceId 网关mac
 @param param 参数
 @param callback 回调
 */
- (void)setWlanRadioInfo:(NSString *)deviceId
                   param:(HwSetWlanRadioInfoParam *)param
            withCallback:(id<HwCallback>)callback;
    
#pragma mark 接口:WAN & LAN(Interface: WAN & LAN)
/**
 *  
 *
 *  @brief 查询所有WAN列表(Query the list of all WANs.)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  回调(callback)
 *
 *  @since 1.0
 */
- (void)queryAllWanBasicInfo:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询WAN接口详情(Query the details of the WAN interface.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param wanName  wan名称(WAN name)
 *  @param callback 返回的回调(returned callback)
 *
 *  @since 1.0
 */
- (void) queryWanDetailInfoByName:(NSString *)deviceId
                      withWanName:(NSString *)wanName
                     withCallback:(id<HwCallback>)callback;


#pragma mark 接口:PPPoE (interface:PPPoE)

/**
 *  
 *
 *  @brief 获取PPPoE帐号 (obtain a PPPoE account)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param wanName  WAN名称(WAN name)
 *  @param callback  回调(callback)
 *
 *  @since 1.0
 */
- (void) getPPPoEAccount:(NSString *)deviceId
             withWanName:(NSString *)wanName
            withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 设置PPPoE帐号 (set a PPPoE account)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param account  账户(account)
 *  @param callback  回调(callback)
 *
 *  @since 1.0
 */
- (void) setPPPoEAccount:(NSString *)deviceId
        withPPPoEAccount:(HwPPPoEAccount *)account
            withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 获取PPPoE拨号状态 (obtain the PPPoE dialing status)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param wanName  WAN名称(WAN name)
 *  @param callback  回调(callback)
 *
 *  @since 1.0
 */
- (void) getPPPoEDialStatus:(NSString *)deviceId withWanName:(NSString *)wanName withCallback:(id<HwCallback>)callback;

#pragma mark Gateway
/**
 *  
 *
 *  @brief 近端登录网关 (log in to the gateway in near-end mode)
 *
 *  @param loginGatewayParam 登录的用户名以及帐号信息 (login user name and password)
 *  @param callback          返回登录成功与否的结果 (return a login result)
 *
 *  @since 1.0
 */
- (void)loginGateway:(HwLoginGatewayParam *)loginGatewayParam
        withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 退出登录网关(log out to the gateway in near-end mode)
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)logoutGateway:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 修改网关密码(modify gateway password in near-end mode)
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)modifyGatewayPassword:(NSString *)deviceId
                    withParam:(HwModifyGatewayPasswordParam *)modifyGatewayPasswordParam
                 withcallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 判断是否为近端接入网关(Judge whether a gateway is a local access gateway.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param callback 返回的回调(returned callback)
 *
 *  @since 1.0
 */
- (void)judgeLocalNetwork:(NSString *)deviceId withCallback:(id<HwCallback>)callback;


/**
 *  
 *
 *  @brief 查询网关信息 (query gateway information)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback 返回的回调(returned callback)
 *
 *  @since 1.0
 */
- (void)getSystemInfo:(NSString *)deviceId withCallback:(id<HwCallback>)callback;


/**
*
*
* @brief 查询ap上一次离线原因
*
* @param deviceId 网关ID (gateway ID)
* @param list 需要查询的APmac集合
* @param callback
*
* @since 1.6.0
*
*/
- (void)getAPSyetemInfo:(NSString *)deviceId withParam:(NSArray *)list CallBack:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 重启网关 (restart the gateway)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)reboot:(NSString *)deviceId withCallback:(id<HwCallback>)callback;
- (void)factoryReset:(NSString *)deviceId withCallback:(id<HwCallback>)callback;
/**
 *  
 *
 *  @brief 强制刷新网关拓扑 (refresh the gateway topo)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void) refreshTopo:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询网关名称 (query a gateway name)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getGatewayName:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 重命名网关 (rename the gateway)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)renameGateway:(NSString *)deviceId gatewayName:(NSString *)gatewayName withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询网关在线时长 (query gateway online duration)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  回调(callback)
 *
 *  @since 1.0
 */
- (void)getGatewayTimeDuration:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询CPU占用率 (query CPU usage)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  回调(callback)
 *
 *  @since 1.6.0
 */
- (void)getCpuPercent:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询内存占用率 (query memory usage)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  回调(callback)
 *
 *  @since 1.6.0
 */
- (void)getMemoryPercent:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询网关当前流量 (query current gateway traffic)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getGatewayTraffic:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询网关当前实时速率量 (query current gateway speed)
 *
 *  @param deviceId 网关ID (gateway ID)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getGatewaySpeed:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

#pragma mark 设备 (device)




#pragma mark 家长控制 (parental control)

/**
 *  
 *
 *  @brief 近端检查网关账号和密码
 *
 *  @param checkGatewayPasswordParam 登录网关参数类 (check Gateway Password Param)
 *  @param callback
 *
 *  @since 1.0
 */
-(void)checkGatewayPassword:(HwCheckGatewayPasswordParam *)checkGatewayPasswordParam
               withCallback:(id<HwCallback>)callback;






/**
 *  
 *
 *  @brief 查询一键体检结果
 *
 *  @param deviceId 网关id (id of gateway)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)getSelfCheckResult:(NSString *)deviceId withCallback:(id<HwCallback>)callback;


/**
 *  
 *
 *  @brief 确认一键体检结果
 *  @param resultId 检查结果id
 *  @param deviceId 网关id (id of gateway)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)acknowledgeSelfCheckParam:(NSString *)deviceId resultId:(NSString*)resultId withCallback:(id<HwCallback>)callback;
;


/**
 *  
 *
 *  @brief 全网信道调优
 *  @param deviceId 网关id (id of gateway)
 *  @param callback
 *
 *  @since 1.0
 */
- (void)triggerWholeNetworkTuning:(NSString *)deviceId
                     withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 获取离线通知
 *
 *  @param deviceId 网关ID
 *  @param callback 回调
 *
 *  @since
 */
- (void)getGateWayOfflineNotifications:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 设置离线通知
 *
 *  @param deviceId 网关ID
 *  @param option 通知类型参数
 *  @param callback 回调
 *
 *  @since
 */
- (void)setGateWayOfflineNotification:(NSString *)deviceId withOfflineNotificationOption:(HwOfflineNotificationOption *)option withCallback:(id<HwCallback>)callback;

/**
 指定频段的网关信道重选
 
 @param deviceId 网关 mac
 @param param 网关信道调优参数
 @param callback 回调
 */
- (void) setGatewayAcsStartWithDeviceId:(NSString *)deviceId param:(HwSetGatewayAcsStartParam *)param withCallback:(id<HwCallback>)callback;

/**
 开始 PING 测试
 
 @param deviceId 网关id
 @param ipPingDiagnosticsInfo ping 测试信息
 @param callback 回调
 */
- (void) startIpPingDiagnosticsWithDeviceId:(NSString *)deviceId
                      ipPingDiagnosticsInfo:(HwIpPingDiagnosticsInfo *)ipPingDiagnosticsInfo
                                   callback:(id<HwCallback>)callback;

/**
 获取 PING 诊断结果
 
 @param deviceId 网关id
 @param callback 回调
 */
- (void) getIpPingDiagnosticsResultWithDeviceId:(NSString *)deviceId callback:(id<HwCallback>)callback;

/**
 查询设备端口映射信息
 
 @param deviceId 网关设备id
 @param callback 回调
 */
- (void) getPortMappingInfoWithDeviceId:(NSString *)deviceId callback:(id<HwCallback>)callback;

/**
 增加端口映射表项（添加后默认开启）
 
 @param deviceId 网关id
 @param singlePortMapping 映射
 @param callback 回调
 */
- (void) addPortMappingWithDeviceId:(NSString *)deviceId
                  singlePortMapping:(HwSinglePortMappingInfo *)singlePortMapping
                           callback:(id<HwCallback>)callback;

/**
 删除端口映射表项
 
 @param deviceId 网关id
 @param switchInfo 映射信息
 @param callback 回调
 */
- (void) deletePortMappingWithDeviceId:(NSString *)deviceId
                 portMappingSwitchInfo:(HwPortMappingSwitchInfo *)switchInfo
                              callback:(id<HwCallback>)callback;

/**
 设置端口映射表项开关
 
 @param deviceId 网关id
 @param switchInfo 映射信息
 @param callback 回调
 */
- (void) setPortMappingSwitchWithDeviceId:(NSString *)deviceId
                    portMappingSwitchInfo:(HwPortMappingSwitchInfo *)switchInfo
                                 callback:(id<HwCallback>)callback;

/**
 查询 DHCP 预留地址
 
 @param deviceId 网关id
 @param macList mac 列表
 @param callback 回调
 */
- (void) getDHCPStaticIPListWithDeviceId:(NSString *)deviceId
                                 macList:(NSArray<NSString *> *)macList
                                callback:(id<HwCallback>)callback;

/**
 增加/设置下挂设备 DHCP 预留 IP
 
 @param deviceId 网关id
 @param ipInfo ip 信息
 @param callback 回调
 */
- (void) setOrAddDHCPStaticIPWithDeviceId:(NSString *)deviceId
                                   ipInfo:(HwDHCPIpInfo *)ipInfo
                                 callback:(id<HwCallback>)callback;

/**
 删除下挂设备 DHCP 预留 IP
 
 @param deviceId 网关id
 @param macList mac列表
 @param callback 回调
 */
- (void) deleteDHCPStaticIPWithDeviceId:(NSString *)deviceId
                                macList:(NSArray<NSString *> *)macList
                               callback:(id<HwCallback>)callback;

/**
 查询流量统计数据
 
 @param deviceId 网关id
 @param config 查询配置信息
 @param callback 回调
 */
- (void) getHomeNetworkTrafficInfoListWithDeviceId:(NSString *)deviceId
                                            config:(HwGetHomeNetworkTrafficInfoListConfig *)config
                                          callback:(id<HwCallback>)callback;

/**
 查询ONT UpLink信息
 @param deviceId 网关mac
 @param callback 回调
 @since 1.2.5(NCE)
 */
-(void)getUplinkInfo:(NSString *)deviceId callback:(id<HwCallback>)callback;

- (void)getGatewayConfigStatus:(NSString *)deviceId isNeedLogin:(BOOL)isNeedLogin callback:(id<HwCallback>)callback;

- (void)setGatewayConfigStatus:(NSString *)deviceId isNeedLogin:(BOOL)isNeedLogin param:(HwSetGatewayConfigStatusParam *)param callback:(id<HwCallback>)callback;

- (void)getInternetWanInfo:(NSString *)deviceId isNeedLogin:(BOOL)isNeedLogin callback:(id<HwCallback>)callback;

- (void)setInternetWanInfo:(NSString *)deviceId isNeedLogin:(BOOL)isNeedLogin param:(HwSetInternetWanInfoParam *)param callback:(id<HwCallback>)callback;

- (void)setWebUserPassword:(NSString *)deviceId isNeedLogin:(BOOL)isNeedLogin param:(HwSetWebUserPasswordParam *)param callback:(id<HwCallback>)callback;

- (void)setWebpwdAndWifiInfo:(NSString *)deviceId isNeedLogin:(BOOL)isNeedLogin param:(HwWebPwdAndWifiInfo *)param callback:(id<HwCallback>)callback;
/**
*
*
* @brief 查询关键设备STA
*
* @param deviceId 网关ID (gateway ID)
* @param param 查询关键设备STA的Mac集合
*
* @since null
*
*/
- (void)getVipSta:(NSString *)deviceId callBack:(id<HwCallback>)callBack;

/**
*
*
* @brief 设置关键设备STA
*
* @param deviceId 网关ID (gateway ID)
* @param param 设置关键设备STA的Mac集合
*
* @since null
*
*/
- (void)setVipSta:(NSString *)deviceId withParam:(NSArray *)staList callBack:(id<HwCallback>)callBack;

@end



