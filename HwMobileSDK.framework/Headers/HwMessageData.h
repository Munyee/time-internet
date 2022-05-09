#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HwMobileSDK/HwMessageService.h>

/**
 *  
 *
 *  @brief 消息数据(message data)
 *
 *  @since 1.0
 */
@interface HwMessageData : NSObject

/** 消息数据(Message data)*/
@property (nonatomic,strong) NSMutableDictionary *data;
/** 消息内容，JSON字符串*/
@property (nonatomic,strong) NSMutableDictionary *msgContentDic;

/** 消息类型(Message type)*/
@property (nonatomic,assign) HwMessageType messageType;
/** 消息名称(Message name)*/
@property (nonatomic,copy) NSString *messageName;

/** 消息流水号，每个家庭的每种消息类型内唯一*/
@property (nonatomic,copy) NSString *sn;
/** 绑定网关的MAC地址(最长128字节，UTF-8编码) *(Bound gateway MAC address (128 bytes at most in UTF-8 code))*/
@property (nonatomic,copy) NSString *deviceId;
/** 消息分类类型*/
@property (nonatomic,copy) NSString *categoryType;
/** 应用插件标识/智能设备SN*/
@property (nonatomic,copy) NSString *categoryNameID;
/** 应用插件名称/智能设备名称*/
@property (nonatomic,copy) NSString *categoryName;
/** 消息来源类型 */
@property (nonatomic,copy) NSString *msgSrcType;
/** 消息来源 */
@property (nonatomic,copy) NSString *msgSrc;
/** 消息来源的名称 */
@property (nonatomic,copy) NSString *msgSrcName;
/** 消息生成时间，采用UTC时间*/
@property (nonatomic,assign) UInt64 msgTime;

/** 消息模板ID*/
@property (nonatomic,copy) NSString *msgEvent;
/** 仅当detailView等于APP时支持该参数*/
@property (nonatomic,copy) NSString *appName;
/** 消息标题*/
@property (nonatomic,copy) NSString *title;
/** 唯一标识*/
@property (nonatomic,copy) NSString *symbolicName;
/** 消息模板的详细链接标识*/
@property (nonatomic,copy) NSString *detailView;
/** 消息参数*/
@property (nonatomic,copy) NSDictionary *paramDic;
/** 消息内容(Message content)*/
@property (nonatomic,copy) NSString *messageContent;
/** 缩略图路径数组*/
@property (nonatomic,strong) NSMutableArray *thumbImageArray;
/** 原图或视频路径数组*/
@property (nonatomic,strong) NSMutableArray *imageOrVideoArray;

// 下面是提供 XConnect接口使用
/** 类型*/
@property (nonatomic,copy) NSString *cmdType;
/** 消息ID */
@property (nonatomic,assign) UInt64 msgId;

@end
