#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 卡片元数据(widget metadata)
 *
 *  @since 1.0
 */
@interface HwWidgetMeta : NSObject

/** 名称 (Name)*/
@property(nonatomic,copy) NSString *name;

/** 国际化标题 (Internationalization title)*/
@property(nonatomic,copy) NSString *title;

/** 卡片入口 (Widget entry)*/
@property(nonatomic,copy) NSString *entry;

/** 卡片图标 (Widget icon)*/
@property(nonatomic,copy) NSString *icon;

@end
