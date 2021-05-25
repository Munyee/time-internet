#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief   自检项信息()
 *
 *  @since 1.6.0
 */
@interface HwSelfCheckItem : NSObject

/** 检查项ID ()*/
@property(nonatomic, copy) NSString *checkItemId;


/** 优化项ID ()*/
@property(nonatomic, copy) NSString *optimizedItemId;


@end
