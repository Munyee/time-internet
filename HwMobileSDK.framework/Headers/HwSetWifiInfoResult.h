
#import <HwMobileSDK/HwResult.h>

/**
 *  
 *
 *  @brief 设置当前WIFI信息操作结果(current Wi-Fi setting result)
 *
 *  @since 1.0
 */
@interface HwSetWifiInfoResult : HwResult

@end

/**
 *  
 *
 *  @brief 批量设置WIFI信息操作结果(multi Wi-Fi setting result)
 *
 */
@interface HwSetWifiInfoListResult : HwResult
/** 成功列表  */
@property (strong, nonatomic) NSMutableArray *successList;
/** 失败列表  */
@property (strong, nonatomic) NSMutableArray *failList;

@end

/**
 *  
 *
 *  @brief 设置WIFI信息成功结果(Wi-Fi setting success result)
 *
 */
@interface HwSetWifiInfoSuccessInfo : NSObject
/** ssidIndex  */
@property (copy, nonatomic) NSString *ssidIndex;

@end

/**
 *  
 *
 *  @brief 设置WIFI信息失败结果(Wi-Fi setting fail result)
 *
 */
@interface HwSetWifiInfoFailInfo : NSObject
/** ssidIndex  */
@property (copy, nonatomic) NSString *ssidIndex;
/** 失败原因  */
@property (copy, nonatomic) NSString *failedReason;

@end
