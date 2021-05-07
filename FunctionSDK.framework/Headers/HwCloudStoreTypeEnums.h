//
//  HwCloudStoreTypeEnums.h
//  FunctionSDK
//

//  Copyright © 2016 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APP_STORAGE_TYPE)
{
    APP_STORAGE_TYPE_UNKNOW      = -1,
    APP_STORAGE_TYPE_APPLICATION = 0,       //0、应用云
    APP_STORAGE_TYPE_FAMILY      = 1,       //2、家庭云
    APP_STORAGE_TYPE_ONT          =2, //3、ONT 存储--暂不支持
};

typedef NS_ENUM(NSInteger, STORAGE_TYPE)
{
    STORAGE_TYPE_UNKNOW = -1,
    STORAGE_TYPE_ONT = 0,           //0、ONT本地存储
    //STORAGE_TYPE_TY_CLOUD =1,       //1、天翼云
    STORAGE_TYPE_WO_CLOUD =2,       //2、沃云
    STORAGE_TYPE_NETOPEN_CLOUD = 3, //3、NetOpen服务器
    //STORAGE_TYPE_AMAZON_CLOUD = 4, //4、亚马逊云
    STORAGE_TYPE_OBSS_CLOUD = 5,    //5、Ocean Stor
};

@interface HwCloudStoreTypeEnums : NSObject

+(NSString*)getAppStorageTypeString:(APP_STORAGE_TYPE)type;
@end
