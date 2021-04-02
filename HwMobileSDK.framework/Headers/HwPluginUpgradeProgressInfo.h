#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 插件升级状态信息(plug-in upgrade status information)
 *
 *  @since 1.0
 */
@interface HwPluginUpgradeProgressInfo : NSObject

/**
 升级对象(Upgrade object)
 */
typedef enum
{
    /** APP插件升级 (Application plug-in upgrade)*/
    kHwPluginUpgradePluginTypeApp,
    /** 网关插件升级 (Gateway plug-in upgrade)*/
    kHwPluginUpgradePluginTypeGateway
} kHwPluginUpgradePluginType;

/**
 升级类型(Upgrade type)
 */
typedef enum
{
    /** 无需升级 (Upgrade not required)*/
    kHwPluginUpgradeTypeNotNeed,
    /** 初次安装 (Initial installation)*/
    kHwPluginUpgradeTypeInit,
    /** 需要升级 (Upgraded required)*/
    kHwPluginUpgradeTypeUpgrade
} kHwPluginUpgradeType;

/**
 插件升级状态(Plug-in upgrade status)
 */
typedef enum
{
    /** 成功 (Succeeded)*/
    kHwPluginUpgradeStatusSuccessed,
    /** 失败 (Failed)*/
    kHwPluginUpgradeStatusFailed,
    /** 升级中 (Upgrading...)*/
    kHwPluginUpgradeStatusProcessing
} kHwPluginUpgradeStatus;

/** 设备id(最长128字节)(Device ID (128 bytes at most))*/
@property(nonatomic, weak) NSString *deviceId;

/** 更新的插件总数 (Updated total plug-in number)*/
@property(nonatomic) int total;

/** 当前升级的插件数  (Number of plug-ins being upgraded)*/
@property(nonatomic) int current;

/** 升级状态 (Upgrade status)*/
@property(nonatomic) kHwPluginUpgradeStatus upgradeStatus;

/** 升级类型 (Upgrade type)*/
@property(nonatomic) kHwPluginUpgradePluginType upgradeType;

/** 插件名 (Plug-in name)*/
@property(nonatomic, weak) NSString * currentName;

@end
