//
//  HwAppMessageCloudFileModel.h
//  FunctionSDK
//

//  Copyright © 2016 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwAppMessageCloudFileModel : NSObject

// 注意：沃云的路径一定要使用“/”作为分隔符
@property (nonatomic,copy) NSString *path;
@end
