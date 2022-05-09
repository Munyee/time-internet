#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 产品元数据(product metadata)
 *
 *  @since 1.0
 */
@interface HwProductMeta : NSObject

/** 产品名称(最长64字节)(Product name (64 bytes at most))*/
@property(nonatomic,copy) NSString *name;

/** 国际化标题 (Internationalization title)*/
@property(nonatomic,copy) NSString *title;

/** 驱动版本信息(driver version information) */
@property(nonatomic, copy) NSString *driverSoftwareVersion;

/** 在线状态图标(online icon) */
@property(nonatomic,copy) NSString *onlineIconPath;

/** 离线状态图标(offline icon) */
@property(nonatomic,copy) NSString *offlineIconPath;

/** 设备分类(device catalog) */
@property(nonatomic,copy) NSString *catalog;

/** 设备分类国际化(device catalog Resource) */
@property(nonatomic,copy) NSString *catalogResource;

/** 设备品牌(device brand) */
@property(nonatomic,copy) NSString *brand;

/** 设备品牌国际化资源(device brand) */
@property(nonatomic,copy) NSString *brandResource;

/** 厂商名称(最长64字节) (Vendor name (64 bytes at most))*/
@property(nonatomic,copy) NSString *manufacturer;

/** 厂商国际化名称(最长64字节)(Vendor internationalization name (64 bytes at most))*/
@property(nonatomic,copy) NSString *manufacturerResource;

/** 密码校验页面地址 */
@property (nonatomic, copy) NSString *passwordEntry;

/**设备的class名称列表*/
@property(nonatomic,strong) NSArray<NSString*>  *classes;

@end
