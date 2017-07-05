
#import <MantleXMLExtension/MXEXmlAdapter.h>
// models
#import "OSTExchangeRate.h"

@interface OSTExchangeRateList : MTLModel <MXEXmlSerializing>

@property (strong, nonatomic, readonly) NSArray *list;

- (OSTExchangeRate *)getExchangeRateWithCurrency:(OSTCurrency)currency;

@end
