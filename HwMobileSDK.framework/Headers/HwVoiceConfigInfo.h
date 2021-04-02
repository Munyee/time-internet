#import <Foundation/Foundation.h>

/**
 用户密码指示 (User password indication)
 */
typedef enum
{
    kHwPasswordIndicatorYES = 1,
    kHwPasswordIndicatorNO
}HwPasswordIndicator;

/**
 *  
 *
 *  @brief 语音配置信息 (voice configurations)
 *
 *  @since 1.6.0
 */
@interface HwVoiceConfigInfo : NSObject

/** 主用服务器地址(IP或域名) (Primary server address, an IP address or domain name)*/
@property(nonatomic, copy) NSString *serverAddress;

/** 主用服务器端口 (Primary server port)*/
@property(nonatomic, copy) NSString *serverPort;

/** 备用服务器地址(IP或域名) (Secondary server address, an IP address or domain name)*/
@property(nonatomic, copy) NSString *secondServerAddress;

/** 备用服务器端口 (Secondary server port)*/
@property(nonatomic, copy) NSString *secondServerPort;

/** 第一个用户用户名(SIP为电话号码，H248为终端物理标识) (First user name, SIP indicates a phone number, H248 indicates a physical terminal identifier)*/
@property(nonatomic, copy) NSString *username1;

/** 第一个用户密码指示。YES：已设置。NO：未设置 (First user password indication. YES: already set. NO: not set)*/
@property(nonatomic) HwPasswordIndicator password1Indicator;

/** 第一个用户用户名(SIP为电话号码，H248为终端物理标识) (Second user name, SIP indicates a phone number, H248 indicates a physical terminal identifier)*/
@property(nonatomic, copy) NSString *username2;

/** 第二个用户密码指示。YES：已设置。NO：未设置 (Second user password indication. YES: already set. NO: not set)*/
@property(nonatomic) HwPasswordIndicator password2Indicator;

@end
