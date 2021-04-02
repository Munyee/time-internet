//
//  FunctionSDKStorageDiscFactory.h
//  HomeLinked
//  存储器工厂类，沃云、天翼云、亚马逊云、本地存储
//

//  Copyright (c) 2015年 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwAppMessageCloudFileModel.h"
#import "HwCloudStoreTypeEnums.h"

@class AbsCloudDisc;
@class AbsCloudFile;


@interface FunctionSDKStorageDiscFactory : NSObject

/**
 * @function createStorageDisc
 *
 * @param[in] (APP_STORAGE_TYPE)storageType  存储类型枚举:
 * @param[io] NSString*)errorCode        错误码
 * @retval AbsCloudDisc*                      AbsDisc*存储盘符基类指针数组
 */
+(AbsCloudDisc*)createStorageDisc:(APP_STORAGE_TYPE)storageType;

+(AbsCloudDisc*)createStorageDiscByInitDic:(NSMutableDictionary*)initDic
                          withAppStoreType:(APP_STORAGE_TYPE)storageType
                                 errorCode:(NSString *)errorCode;

+(AbsCloudDisc*)createStorageDiscByFile:(AbsCloudFile*)file;

+(AbsCloudFile*)createStorageFileByInitDic:(NSMutableDictionary*)initDic
                               storageType:(APP_STORAGE_TYPE)storageType;

typedef void(^getAbsFileCallBack)(AbsCloudFile* targetFile);
-(void)createStorageFileWithMessageModel:(HwAppMessageCloudFileModel*)messageModel
                       withStorageType:(APP_STORAGE_TYPE)storageType
                          withCallBack:(getAbsFileCallBack)callBack;

typedef void(^getAbsDiscCallBack)(AbsCloudDisc* targetDisc);
-(void)createStorageDiscWithPath:(NSString*)cloundpath
                         withStorageType:(APP_STORAGE_TYPE)storageType
                            withCallBack:(getAbsDiscCallBack)callBack;

+ (NSMutableDictionary *)createUploadTaskByPathInfo:(AbsCloudDisc *)destDisc mediaFile:(NSDictionary *)mediaFile;
@end

