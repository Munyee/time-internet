#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief WAN基本信息(basic WAN information)
 *
 *  @since 1.0
 */
@interface HwWanBasicInfo : NSObject

/** 序号 (Number)*/
@property(nonatomic) int index;

/** 描述 (Description)*/
@property(nonatomic,strong) NSString *wanDescription;

@end
