
#import "OSTExchangeRateList.h"

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

#pragma mark - Public methods -

- (OSTExchangeRate *)getExchangeRateWithCurrency:(OSTCurrency)currency
{
    for (OSTExchangeRate *rate in _list)
    {
        if ([rate currency] == currency) {
            return rate;
        }
    }
    return nil;
}

@end
