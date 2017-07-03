
#import <MantleXMLExtension/MXEXmlAdapter.h>

@interface OSTExchangeRateList : MTLModel <MXEXmlSerializing>

@property (strong, nonatomic, readonly) NSArray *list;

@end
