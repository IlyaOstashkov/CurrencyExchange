
#import <MantleXMLExtension/MXEXmlAdapter.h>

typedef NS_ENUM(NSUInteger, OSTCurrency)
{
    OSTCurrencyEUR,
    OSTCurrencyUSD,
    OSTCurrencyJPY,
    OSTCurrencyBGN,
    OSTCurrencyCZK,
    OSTCurrencyDKK,
    OSTCurrencyGBP,
    OSTCurrencyHUF,
    OSTCurrencyPLN,
    OSTCurrencyRON,
    OSTCurrencySEK,
    OSTCurrencyNOK,
    OSTCurrencyHRK,
    OSTCurrencyRUB,
    OSTCurrencyTRY,
    OSTCurrencyAUD,
    OSTCurrencyBRL,
    OSTCurrencyCAD,
    OSTCurrencyCNY,
    OSTCurrencyHKD,
    OSTCurrencyIDR,
    OSTCurrencyILS,
    OSTCurrencyINR,
    OSTCurrencyKRW,
    OSTCurrencyMXN,
    OSTCurrencyMYR,
    OSTCurrencyNZD,
    OSTCurrencyPHP,
    OSTCurrencySGD,
    OSTCurrencyTHB,
    OSTCurrencyZAR
};

@interface OSTExchangeRate : MTLModel <MXEXmlSerializing>

@property (strong, nonatomic) NSString *currencyString;
@property (strong, nonatomic) NSNumber *rate;

- (OSTCurrency)currency;

@end
