#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwParam.h>

#import <HwMobileSDK/HwMessageService.h>

/**
 * 查询家信消息方向(Query a home message direction)
 *
 */
typedef enum
{
    /** 从当前sn开始查询最新消息记录 (Latest record)*/
    kHwMessageFoward = 0,
    /** 从当前SN开始查询历史消息记录 (Forward based on the current SN)*/
    kHwMessageBack,
    /** 从指定消息流水号列表查询 (Forward based on the current SN List) */
    kHwMessageCurrentSnList,
    /** 从指定消息流水号段查询 (Forward based on the current SN Param)*/
    kHwMessageCurrentSnParam
} kHwMessageDirection;

/**

 *
 *  @brief 装维消息查询参数(message query parameters)
 *
 *  @since 1.0
 */
@interface HwMessageQueryParam : HwParam

/** 当前SN编号 (Current SN number)*/
@property(nonatomic,assign) long currentSn;

/** 获取最大记录条数 (Obtain the maximum record number)*/
@property(nonatomic,assign)long maxCount;

/** 获取记录的方向 (Obtain a record direction)*/
@property(nonatomic,assign)kHwMessageDirection direction;

/** 消息类型 (Message type)*/
@property(nonatomic,assign)HwMessageType messageType;

/** 用户组ID*/
@property(nonatomic,copy)NSString *groupId;

/** 需要查询的SN列表 */
@property(nonatomic,copy)NSArray *snList;

/** 开始Sn */
@property(nonatomic,copy)NSString *startSN;

/** 结束SN */
@property(nonatomic,copy)NSString *endSN;
@end

