
#import "OSTExchangeRate.h"

@implementation OSTExchangeRate

#pragma mark - MXEXmlSerializing -

+ (NSDictionary<NSString*, id>* _Nonnull)xmlKeyPathsByPropertyKey
{
    return @{ NSStringFromSelector(@selector(currencyString)) : MXEXmlAttribute(@"Cube", @"currency"),
              NSStringFromSelector(@selector(rate)) : MXEXmlAttribute(@"Cube", @"rate")};
}

+ (NSString* _Nonnull)xmlRootElementName
{
    return @"Cube";
}

- (OSTCurrency)currency
{
    NSDictionary *currencyDict = @{
                                   @"USD" : @(OSTCurrencyUSD),
                                   @"JPY" : @(OSTCurrencyJPY),
                                   @"BGN" : @(OSTCurrencyBGN),
                                   @"CZK" : @(OSTCurrencyCZK),
                                   @"DKK" : @(OSTCurrencyDKK),
                                   @"GBP" : @(OSTCurrencyGBP),
                                   @"HUF" : @(OSTCurrencyHUF),
                                   @"PLN" : @(OSTCurrencyPLN),
                                   @"RON" : @(OSTCurrencyRON),
                                   @"SEK" : @(OSTCurrencySEK),
                                   @"NOK" : @(OSTCurrencyNOK),
                                   @"HRK" : @(OSTCurrencyHRK),
                                   @"RUB" : @(OSTCurrencyRUB),
                                   @"TRY" : @(OSTCurrencyTRY),
                                   @"AUD" : @(OSTCurrencyAUD),
                                   @"BRL" : @(OSTCurrencyBRL),
                                   @"CAD" : @(OSTCurrencyCAD),
                                   @"CNY" : @(OSTCurrencyCNY),
                                   @"HKD" : @(OSTCurrencyHKD),
                                   @"IDR" : @(OSTCurrencyIDR),
                                   @"ILS" : @(OSTCurrencyILS),
                                   @"INR" : @(OSTCurrencyINR),
                                   @"KRW" : @(OSTCurrencyKRW),
                                   @"MXN" : @(OSTCurrencyMXN),
                                   @"MYR" : @(OSTCurrencyMYR),
                                   @"NZD" : @(OSTCurrencyNZD),
                                   @"PHP" : @(OSTCurrencyPHP),
                                   @"SGD" : @(OSTCurrencySGD),
                                   @"THB" : @(OSTCurrencyTHB),
                                   @"ZAR" : @(OSTCurrencyZAR),
                                   };
    if (!_currencyString.length) {
        return OSTCurrencyUSD; // default value
    }
    return [[currencyDict valueForKey:_currencyString] integerValue];
}

@end
