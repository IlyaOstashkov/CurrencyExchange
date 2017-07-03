
#import "OSTAppAssembly.h"
#import "OSTHelperAssembly.h"
#import "OSTAppDelegate.h"
// controllers
#import "OSTExchangeVC.h"
// vendors
#import "TyphoonFactoryDefinition.h"

@implementation OSTAppAssembly

- (OSTAppDelegate *)appDelegate
{
    return [TyphoonDefinition withClass:[OSTAppDelegate class]
                          configuration:^(TyphoonDefinition *definition)
    {
        [definition injectProperty:@selector(rootViewController)
                              with:[self exchangeVC]];
    }];
}

- (OSTExchangeVC *)exchangeVC
{
    return [TyphoonDefinition withClass:[OSTExchangeVC class]
                          configuration:^(TyphoonDefinition *definition)
    {
        [definition injectProperty:@selector(exchangeHelper)
                              with:[_helperAssembly exchangeHelper]];
    }];
}

@end
