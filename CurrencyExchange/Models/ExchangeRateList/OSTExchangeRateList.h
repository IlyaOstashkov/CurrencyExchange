
#import <MantleXMLExtension/MXEXmlAdapter.h>
// models
#import "OSTExchangeRate.h"

@interface OSTExchangeRateList : MTLModel <MXEXmlSerializing>

@property (strong, nonatomic, readonly) NSArray *list;

/**
 Get exchange rate from list with currency
 */
- (OSTExchangeRate *)getExchangeRateWithCurrency:(OSTCurrency)currency;

@end
