#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwResult.h>
#import <HwMobileSDK/HwSelfCheckItem.h>
/**
 *  
 *
 *  @brief  查询一键体检返回结果 (query result)
 *
 *  @since
 */
@interface HwSelfCheckResult : HwResult

/** 检查结果Id() */
@property(nonatomic, copy) NSString *resultId;

/** 是否已经确认过() */
@property (nonatomic, copy)NSString  *acknowledge;

/** 确认结果列表() */
@property (nonatomic, strong) NSMutableArray<HwSelfCheckItem *> *selfCheckItemList;

@end
