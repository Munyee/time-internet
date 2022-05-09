#import <Foundation/Foundation.h>


/**
 网关升级信息(Gateway upgrade information)
 */
@interface HwGatewayUpgradeInfo : NSObject 
    
/** 版本名称 (Version name)*/
@property(nonatomic,copy) NSString *versionName;

/** 版本描述 (Version description)*/
@property(nonatomic,copy) NSString *versionDescribe;
	
@end
