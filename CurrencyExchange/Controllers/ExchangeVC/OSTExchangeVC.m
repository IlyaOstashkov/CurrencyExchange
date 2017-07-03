
#import "OSTExchangeVC.h"
// protocols
#import "OSTServerHelper.h"
// models
#import "OSTExchangeRate.h"

@interface OSTExchangeVC ()

@end

@implementation OSTExchangeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_serverHelper getExchangeRatesWithCompletion:^(NSArray *response,
                                                    NSError *error)
    {
        OSTExchangeRate *exchangeRate = response[2];
        OSTCurrency currency = [exchangeRate currency];
        NSLog(@"%lu", (unsigned long)currency);
    }];
}

@end
