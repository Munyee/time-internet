//
//  HwOfflineNotification.h
//  HwMobileSDK
//

//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HwNotificationType) {
	kHwNotificationType_APP,        //家信
	kHwNotificationType_SMS,        //短信
	kHwNotificationType_EMAIL,      //邮件
};

@interface HwOfflineNotification : NSObject

@property (nonatomic,assign) HwNotificationType notificationType;

@end
