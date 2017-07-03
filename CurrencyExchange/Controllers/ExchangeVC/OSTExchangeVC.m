
#import "OSTExchangeVC.h"
// protocols
#import "OSTServerHelper.h"

@interface OSTExchangeVC ()

@end

@implementation OSTExchangeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_serverHelper getExchangeRatesWithCompletion:^(id response,
                                                    NSError *error)
    {
        //
    }];
}

@end
