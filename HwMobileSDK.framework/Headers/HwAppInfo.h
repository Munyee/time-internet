#import <Foundation/Foundation.h>


/**
 *  
 *
 *  @brief 应用信息(application introduction)
 *
 *  @since 1.0
 */
@interface HwAppInfo : NSObject
	
/** 应用ID(最长64字节) (Application ID (64 bytes at most))*/
@property(nonatomic,copy) NSString * appId;

/** 应用名称 (Application name)*/
@property(nonatomic,copy) NSString * name;

/** 国际化字符串 (Internationalization character string)*/
@property(nonatomic,copy) NSString * title;

/** 应用图标 (Application icon)*/
@property(nonatomic,copy) NSString * image;

/** 安装状态 (Installation status)*/
@property(nonatomic) BOOL installStatus;

/** 是否需要升级 (Whether need upgrade) */
@property(nonatomic) BOOL needUpgrade;

/** 购买状态 (Purchase status)*/
@property(nonatomic) BOOL buyStatus;

/** 是否免费 (Free or not)*/
@property(nonatomic) BOOL isFree;

@end
