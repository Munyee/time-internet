
#import <Foundation/Foundation.h>
/**
 *  
 *
 *  @brief 发送聊天消息(send message data)
 *
 *  @since 1.7
 */

typedef enum{
    HwDestAccountTypeConsumer,
    HwDestAccountTypeOmuser,
    HwDestAccountTypeGroup
} HwDestAccountType;

@interface HwSendMessageData : NSObject

/** 消息内容(message content) */
@property(nonatomic,copy) NSString *content;

/** 目的账号类型 */
@property (nonatomic ,assign)HwDestAccountType  destAccountType;
/** 目的账号 */
@property (nonatomic ,copy)NSString *msgDest;
/** 聊天内容 */
@property (nonatomic ,copy)NSString *chatInfo;
/** 扩展参数 */
@property (nonatomic ,strong)NSMutableDictionary *params;

/** 发送账号 */
@property (nonatomic ,copy)NSString *msgSrc;

@end
