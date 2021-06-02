#import <Foundation/Foundation.h>

/**
 *
 *  @brief 云存储文件对象
 *
 *  @since 
 */
@interface HwCloudStorageObject : NSObject

/** 文件名 */
@property(nonatomic,copy) NSString *name;

/** 文件大小 字节 */
@property (nonatomic,strong) NSNumber *size;

/** 是否为文件夹 */
@property BOOL isFolder;

/** 文件创建时间 */
@property (nonatomic,copy) NSString *createTime;

/** 唯一键值 */
@property (nonatomic,copy) NSString *key;
 
/** */
@property (nonatomic,copy) NSString *fileURL;

/** 是否支持流 */
@property BOOL isSupportStream;

/** 对应的设备SN */
@property (nonatomic,copy) NSString *deviceSn;

@end
