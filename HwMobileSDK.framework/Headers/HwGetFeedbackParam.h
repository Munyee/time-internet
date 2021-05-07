//
//  HwGetFeedbackParam.h
//  HwMobileSDK
//
//  Created by zhangwenjie on 2017/12/11.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    kHwFeedbackQueryTypeAll = -1,//全部
    kHwFeedbackQueryTypeUnReply = 0,//未回复
    kHwFeedbackQueryTypeReply = 1,//已回复
}HwFeedbackQueryType;
@interface HwGetFeedbackParam : NSObject
/** 查询类型 */
@property (nonatomic ,assign) HwFeedbackQueryType queryType;
/** 分页查询页数  */
@property (nonatomic, assign) NSInteger pageNo;
/** 分页查询的每页记录数 */
@property (nonatomic, assign) NSInteger pageSize;
@end
