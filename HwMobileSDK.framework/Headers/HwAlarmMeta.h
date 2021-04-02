#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 告警信息(alarm information)
 *
 *  @since 1.0
 */
@interface HwAlarmMeta : NSObject

/** 名称(最长64字节) (Name (64 bytes at most))*/
@property(nonatomic,copy) NSString *name;

/** 国际化标题 (Internationalization title)*/
@property(nonatomic,copy) NSString *title;

@end
