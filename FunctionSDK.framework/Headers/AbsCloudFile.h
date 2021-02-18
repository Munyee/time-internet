//
//  FileAbs.h
//  HomeLinked
//

//  Copyright (c) 2015年 Huawei. All rights reserved.
//

#ifndef FILE_ABS_h
#define FILE_ABS_h

#import "FunctionSDKStorageDiscFactory.h"
@class AbsCloudFile;

@protocol FileRequestDelegate <NSObject>

@optional

//重命名
-(void)request:(AbsCloudFile *)request renameFileSuccess:(NSString *)newFileName;
-(void)request:(AbsCloudFile *)request renameFileError:(NSString *)errorCode;

//删除
-(void)request:(AbsCloudFile *)request deleteFileSuccess:(NSString *)fileName;
-(void)request:(AbsCloudFile *)request deleteFileError:(NSString *)errorCode;

//复制
-(void)request:(AbsCloudFile *)request copyFileSuccess:(NSString *)errorCode;
-(void)request:(AbsCloudFile *)request copyFileError:(NSString *)errorCode;

// 下载
-(void)request:(AbsCloudFile *)request downloadFileSuccess:(NSString *)filePath;
-(void)request:(AbsCloudFile *)request downloadingFile:(long)downloadedSize  speed:(NSString*)speed;
-(void)request:(AbsCloudFile *)request downloadFileError:(NSString *)errorCode;

//缩略图
-(void)request:(AbsCloudFile *)request getImageIconSuccess:(UIImage *)image;
-(void)request:(AbsCloudFile *)request getImageIconFail:(NSString *)errCode;

//播放视频
-(void)request:(AbsCloudFile *)request playVideoSuccess:(NSString *)url;
-(void)request:(AbsCloudFile *)request playVideoFail:(NSString *)errCode;

@end



@interface AbsCloudFile:NSObject
// 文件名
@property (nonatomic,copy) NSString * fileName;

// 物理文件夹名称
@property (nonatomic,copy) NSString * phyFolderName;

// 文件创建时间
@property (nonatomic,copy) NSString *createTime;

// 是否为文件夹
@property (nonatomic, assign) BOOL isFolder;

// 文件大小 字节
@property (nonatomic,strong) NSNumber * fileSize;

// 存储类型
@property STORAGE_TYPE storageType;

// 文件下载URl
@property (nonatomic,copy) NSString *fileUrl;

// 文件下载URl
@property (nonatomic,copy) NSString *cloudPath;

// 家庭云还是应用云
@property APP_STORAGE_TYPE  availableCloudType;

//委托
@property(nonatomic ,strong)id <FileRequestDelegate> delegate;

//实例转换为字典
- (NSMutableDictionary*)objectToDic;
//字典转换为实例
- (instancetype)initWithDic:(NSMutableDictionary*)initDic
         withAvailableCloud:(APP_STORAGE_TYPE)availableCloudType;

//修改文件/文件夹名称
-(void)renameFile:(NSString *)newFileName;  //放到file

//删除文件/文件夹（单个删除）
-(void)deleteFile;  //单个的放到file

//复制文件及文件夹
typedef void(^HLmoveCopyFileCallback)(NSString* ErrorCode);
-(void)moveFile:(AbsCloudDisc *)desFolder withCallBack:(void(^)(NSString *errCode))callBack;

-(void)copyFile:(AbsCloudDisc *)desFolder withCallBack:(void(^)(NSString *errCode))callBack; //放到file

/**
 *
 *  @brief 下载文件到指定的沙盒路径（一次性下载）
 *
 *  @param downloadPath 本地路径
 *
 *  @since V100R001C00
 */
-(void)downloadFile:(NSString*)downloadPath;

// 获取缩略图
typedef void(^HLgetImageCallback)(NSString* ErrorCode,UIImage* image);
-(void)getImage:(HLgetImageCallback)callback;
-(void)getImageWithSN:(NSString *)sn
         withCallback:(HLgetImageCallback)callback;

//格式化文件大小
-(NSString*)formatFileSize;

typedef void(^HLgetPlayVideoUrlCallback)(NSString* ErrorCode,NSString* url);
-(void)getPlayVideoUrl:(HLgetPlayVideoUrlCallback)callback;

/**
 *
 *  @brief 获取云存储文件的全球唯一标识(云存储上的完整路径)
 *
 *  @since V100R001C00
 */
-(NSString*)getKey;

#pragma mark 云存储能力
/**
 *
 *  @brief 是否支持流
 *
 *  @return
 *
 *  @since
 */
- (BOOL)isSupportStream;

- (void)pauseDownloading;

@end
#endif
