
#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwWlanNeighborInfo.h>
#import <HwMobileSDK/HwApTrafficInfo.h>

/**
 *  
 *
 *  @brief 周边wifi及路况信息对象( )
 *
 *  @since 1.6
 */
@interface HwApWlanNeighborInfo : NSObject
/**  周边WIFI信息(Wi-Fi networks nearby)*/
@property(nonatomic,copy) NSArray <HwWlanNeighborInfo *>* apWlanNeighborList;

/** 路况信息 ()*/
@property(nonatomic,copy) NSArray <HwApTrafficInfo *>* apTrafficInfoList;
@end
