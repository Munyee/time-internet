#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief PON信息(PON information)
 *
 *  @since 1.0
 */
@interface HwPonInformation : NSObject
/** 光模块温度；(单位：摄氏度 )(Optical module temperature (℃))*/
@property(nonatomic, copy) NSString *temperature;

/** Vottage表示电压；(单位：V)(Voltage (V))*/
@property(nonatomic, copy) NSString *vottage;

/** Current表示电流；(单位：mA)(Current (mA))*/
@property(nonatomic, copy) NSString *current;

/** TXPower 表示发送光功率；(单位：dBm) (Transmit optical power (dBm))*/
@property(nonatomic, copy) NSString *txPower;

/** TXPower 表示发送光功率min；(单位：dBm) (Transmit optical power (dBm))*/
@property(nonatomic, copy) NSString *txPowerMin;

/** TXPower 表示发送光功率max；(单位：dBm) (Transmit optical power (dBm))*/
@property(nonatomic, copy) NSString *txPowerMax;

/** RXPower 接收光功率；(单位：dBm)(Receive optical power (dBm))*/
@property(nonatomic, copy) NSString *rxPower;

/** RXPower 接收光功率min；(单位：dBm)(Receive optical power (dBm))*/
@property(nonatomic, copy) NSString *rxPowerMin;

/** RXPower 接收光功率max；(单位：dBm)(Receive optical power (dBm))*/
@property(nonatomic, copy) NSString *rxPowerMax;

@end
