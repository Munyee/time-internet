#import <Foundation/Foundation.h>


/**
 *  
 *
 *  @brief 应用详情(application details)
 *
 *  @since 1.0
 */
@interface HwAppDetail : NSObject

/** 最新应用版本 (Lastest application version) */
@property(nonatomic,copy) NSString *version;

/** 已安装应用版本 (Installed application version) */
@property(nonatomic,copy) NSString *installedVersion;

/** 应用开发者 (Application developer)*/
@property(nonatomic,copy) NSString *developer;

/** 文件大小 (File size)*/
@property(nonatomic,assign) int fileSize;

/** 应用介绍信息 (Application introduction)*/
@property(nonatomic,copy) NSString *detail;

@end
