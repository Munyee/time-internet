#import <Foundation/Foundation.h>

/**
 过滤策略 (Filtering policy)
 */
typedef enum
{
    kHwUrlFilterPolicyWhiteList = 0,
    kHwUrlFilterPolicyBlackList = 1
} HwUrlFilterPolicy;

/**
 *  
 *
 *  @brief 家长控制模版 (parental control template)
 *
 *  @since 1.0
 */
@interface HwAttachParentControlTemplate : NSObject

/** 家长控制模板名称(最长32字节,UTF-8编码) (Parental control template name, containing a maximum of 32 bytes. UTF-8 coding format)*/
@property (nonatomic , copy) NSString *name;

/** 允许上网时段 (Internet availability period)*/
@property (nonatomic , strong) NSMutableArray/*<HwControlSegment>*/ *controlList;

/** 是否使能URL过滤 (Whether to enable URL filtering)*/
@property (nonatomic) BOOL urlFilterEnable;

/** 过滤策略 (Filtering policy)*/
@property (nonatomic) HwUrlFilterPolicy urlFilterPolicy;

/** url过滤列表 (URL filtering list)*/
@property (nonatomic , strong) NSMutableArray *urlFilterList;

/** 设备总开关 true:启用  false:禁用 */
@property (nonatomic , assign) BOOL enable;

/** 模板别称 */
@property (nonatomic , copy) NSString *aliasName;

/** 设备列表 */
@property (nonatomic , copy) NSMutableArray *macList;

@end
