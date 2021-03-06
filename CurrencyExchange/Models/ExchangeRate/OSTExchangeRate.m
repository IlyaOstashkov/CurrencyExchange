
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

#pragma mark - Public methods

- (OSTCurrency)currency
{
    if (!_currencyString.length) {
        return OSTCurrencyEUR; // default value
    }
    NSDictionary *currencyDict = [OSTExchangeRate currencyDict];
    return [[currencyDict valueForKey:_currencyString] integerValue];
}

- (NSString *)currencySymbol
{
    NSDictionary *currencySymbolDict = [OSTExchangeRate currencySymbolDict];
    NSString *symbol = [currencySymbolDict objectForKey:@([self currency])];
    return symbol ?: @"";
}

#pragma mark - Private methods -

+ (NSDictionary *)currencyDict
{
    return @{
             @"EUR" : @(OSTCurrencyEUR),
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
}

+ (NSDictionary *)currencySymbolDict
{
    return @{
             @(OSTCurrencyEUR) : @"€",
             @(OSTCurrencyUSD) : @"$",
             @(OSTCurrencyGBP) : @"£"
             };
}

@end
