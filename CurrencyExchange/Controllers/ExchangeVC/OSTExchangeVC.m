
#import "OSTExchangeVC.h"
// protocols
#import "OSTExchangeHelper.h"
// models
#import "OSTExchangeRate.h"

@interface OSTExchangeVC ()

@end

@implementation OSTExchangeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_exchangeHelper getExchangeRateArrayWithCompletion:^(NSArray *rateArray,
                                                          NSError *error)
    {
        OSTExchangeRate *exchangeRate = rateArray[5];
        OSTCurrency currency = [exchangeRate currency];
        NSLog(@"%lu", (unsigned long)currency);
    }];
}

@end
