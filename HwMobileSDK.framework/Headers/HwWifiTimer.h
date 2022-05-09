#import <Foundation/Foundation.h>

/**
 WIFI定时信息(Wi-Fi timing information)
 */
@interface HwWifiTimer : NSObject

/** 是否 启用 (Enabled or not)*/
@property(nonatomic) BOOL enabled;

/** Wifi开机的时间，如：9:30 (Wi-Fi startup time, 9:30 for example)*/
@property(nonatomic, copy) NSString * startTime;

/** Wifi关机的时间，如：9:30 (Wi-Fi shutdown time, 9:30 for example)*/
@property(nonatomic, copy) NSString * endTime;
	
@end
