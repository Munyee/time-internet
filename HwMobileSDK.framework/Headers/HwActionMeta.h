#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 产品的动作(product action )
 *
 *  @since 1.0
 */
@interface HwActionMeta : NSObject

typedef enum
{
    kHwActionTypeAction = 1
}kHwActionType;

/** 动作类型  (Action type)*/
@property(nonatomic) kHwActionType type;

/** 名称(最长64字节)(Name (64 bytes at most))*/
@property(nonatomic,copy) NSString *name;

/** 国际化标题 (Internationalization title)*/
@property(nonatomic,copy) NSString *title;

/** rendered 描述 (rendered discription) */
@property(nonatomic,copy) NSString *rendered;

/** 设备动作所属的class名称 (the class of action) */
@property(nonatomic,copy) NSString *deviceClass;
@end
