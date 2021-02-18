//
//  DiscAbs.h
//  HomeLinked
//  存储盘符抽象基类

//  Copyright (c) 2015年 Huawei. All rights reserved.
//

#ifndef DISC_ABS_h
#define DISC_ABS_h

#import <Foundation/Foundation.h>
#import "AbsCloudFile.h"
@class AbsCloudDisc;

@protocol DiscRequestDelegate <NSObject>

@optional
-(void)request:(AbsCloudDisc*)request connectDiscResult:(NSString *)errorCode;

/**
 * @function loadDiscStatusFinish
 *           获取到存储盘符数据
 * @param[out]  (NSArray*)discs       存储盘符列表
 * @param[out]  (NSString*)errorCode  错误码 “0” 为成功
 * @retval void
 */
-(void)request:(AbsCloudDisc*)request loadDiscStatusSuccess:(NSArray*)discs;
-(void)request:(AbsCloudDisc*)request loadDiscStatusError:(NSString *)errorCode;


/**
 * @function getFileListInFolderSuccess
 *           获取到存储盘符下的文件列表
 * @param[out]  (NSArray*)discs       存储盘符列表
 * @param[out]  (NSString*)errorCode  错误码 “0” 为成功
   @param[out]  (BOOL)isTruncated     A flag that indicates whether or not Amazon S3 returned all of the results that satisfied the search criteria.
 * @retval void
 */
-(void)request:(AbsCloudDisc*)request getFileListInFolderSuccess:(NSArray*)files isTruncated:(BOOL)isTruncated;
-(void)request:(AbsCloudDisc*)request getFileListInFolderError:(NSString*)errorCode;


/**
 * @function getFileListInFolderSuccess
 *           根据文件ID获取文件列表
 * @param[out]  (NSArray*)discs       存储盘符列表
 * @param[out]  (NSString*)errorCode  错误码 “0” 为成功
 * @retval void
 */
-(void)request:(AbsCloudDisc*)request getTargetFileListByIdSuccess:(NSArray*)files;
-(void)request:(AbsCloudDisc*)request getTargetFileListByIdError:(NSString*)errorCode;


/**
 * @function getFilesNumSuccess
 *           获取到存储盘符下的文件个数
 * @param[out]  (NSArray*)discs       存储盘符列表
 * @param[out]  (NSString*)errorCode  错误码 “0” 为成功
 * @retval void
 */
-(void)request:(AbsCloudDisc *)request getFilesNumSuccess:(int)fileNum;
-(void)request:(AbsCloudDisc *)request getFilesNumError:(NSString*)errorCode;

//新建文件夹
-(void)request:(AbsCloudDisc *)request createFolderSuccess:(AbsCloudFile *)newFolder;
-(void)request:(AbsCloudDisc *)request createFolderError:(NSString *)errorCode;

//删除
-(void)request:(AbsCloudDisc *)request deleteFileSuccess:(NSString *)errorCode;
-(void)request:(AbsCloudDisc *)request deleteFileError:(NSString *)errorCode;

//移动
-(void)request:(AbsCloudDisc *)request moveFileSuccess:(NSString *)errorCode;
-(void)request:(AbsCloudDisc *)request moveFileError:(NSString *)errorCode;

// 上传文件
-(void)request:(AbsCloudDisc *)request uploadFileSuccess:(NSString *)errorCode;
-(void)request:(AbsCloudDisc *)request uploadFileError:(NSString *)errorCode;
-(void)request:(AbsCloudDisc *)request uploadingFile:(long)uploadedSize;

//搜索文件／文件夹总数
-(void)request:(AbsCloudDisc *)request searchFileNumSuccess:(int)fileNum :(NSString *)key;
-(void)request:(AbsCloudDisc *)request searchFileNumError:(NSString *)errorCode;

//查找指定文件/文件夹
-(void)request:(AbsCloudDisc *)request getTargetFileResult:(AbsCloudFile *)targetFile errorCode:(NSString*)errorCode;

//显示搜索文件／文件夹列表
-(void)request:(AbsCloudDisc *)request searchFileListSuccess:(NSString *)errorCode;
-(void)request:(AbsCloudDisc *)request searchFileListError:(NSString *)errorCode;

@end



@interface AbsCloudDisc : NSObject

// 存储盘名称
@property (nonatomic,copy) NSString * discName;

// 存储路径(云端)
@property (nonatomic,copy) NSString * discMountPath;

// 创建时间
@property (nonatomic,copy)NSString *createTime;

// 剩余可用大小
@property (nonatomic,strong) NSNumber * discFreeSize;

// 总共可用空间
@property (nonatomic,strong) NSNumber * discTotalSize;

// 存储已用空间
@property (nonatomic,strong) NSNumber * discUsedSize;

// 存储云的类型
@property STORAGE_TYPE storageType;

// 家庭云还是应用云
@property APP_STORAGE_TYPE  availableCloudType;
// 委托
@property (nonatomic,strong)id <DiscRequestDelegate> delegate;

//实例转换为字典
- (NSMutableDictionary*)objectToDic;
//字典转换为实例
- (instancetype)initWithDic:(NSMutableDictionary*)initDic;

+(AbsCloudDisc*)createStorageDisc:(AbsCloudFile*)file;

// 连接存储器
-(void)connect;
// 加载存储状态数据
-(void)loadDiscStatus;

// 获取文件列表
-(void)getFileListInFolder:(int)startIndex :(int)endIndex :(NSString*)orderType;
-(void)getFileListInFolder:(int)pageNum withPageSize:(int)pageSize;

//新建文件夹
-(void)createFolder:(NSString *)folderName;

//批量删除
-(void)deleteFiles:(NSArray*)filesArray;// 文件夹disc中

//移动文件
-(void)moveFile:(NSArray *)fileName :(NSString *)newFolderName;

//搜索文件／文件夹总数
-(void)searchFileNum:(NSString *)key;

-(void)getFileByName:(NSString*)forldName  isForlder:(BOOL)isForlder;

#pragma mark 上传相关
// 开始上传文件
// 注意：该方法是没有任务调度的，上传文件请通过addUploadTask 然后 startUploadFile 进行上传文件
-(void)uploadFile:(NSDictionary*)mediaFile;

/** 停止上传*/
- (void)stopUploadingFile;

#pragma mark 下载相关

@end
#endif
