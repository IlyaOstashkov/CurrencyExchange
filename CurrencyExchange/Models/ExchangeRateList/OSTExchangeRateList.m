
#import "OSTExchangeRateList.h"
// models
#import "OSTExchangeRate.h"

@implementation OSTExchangeRateList

#pragma mark - MXEXmlSerializing -

+ (NSDictionary<NSString*, id>* _Nonnull)xmlKeyPathsByPropertyKey
{
    return @{ NSStringFromSelector(@selector(list)) : MXEXmlArray(@"Cube.Cube",
                                                                  MXEXmlChildNode(@""))};
}

+ (NSString* _Nonnull)xmlRootElementName
{
    return @"gesmes:Envelope";
}

+ (NSValueTransformer* _Nonnull)listXmlTransformer
{
    return [MXEXmlAdapter xmlNodeArrayTransformerWithModelClass:[OSTExchangeRate class]];
}

@end
