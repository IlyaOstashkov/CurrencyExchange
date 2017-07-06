
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
        [definition injectProperty:@selector(securityHelper)
                              with:[_helperAssembly securityHelper]];
    }];
}

- (OSTExchangeVC *)exchangeVC
{
    return [TyphoonDefinition withClass:[OSTExchangeVC class]
                          configuration:^(TyphoonDefinition *definition)
    {
        [definition injectProperty:@selector(serverHelper)
                              with:[_helperAssembly serverHelper]];
        [definition injectProperty:@selector(hudHelper)
                              with:[_helperAssembly hudHelper]];
        [definition injectProperty:@selector(securityHelper)
                              with:[_helperAssembly securityHelper]];
    }];
}

@end
