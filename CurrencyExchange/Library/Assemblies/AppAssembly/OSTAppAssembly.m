
#import "OSTAppAssembly.h"
#import "OSTHelperAssembly.h"
#import "OSTAppDelegate.h"
// controllers
#import "OSTExchangeVC.h"
// vendors
#import "TyphoonFactoryDefinition.h"

@implementation OSTAppAssembly

#pragma mark - Private injections -

- (OSTAppDelegate *)appDelegate
{
    return [TyphoonDefinition withClass:[OSTAppDelegate class]
                          configuration:^(TyphoonDefinition *definition)
    {
        [definition injectProperty:@selector(rootViewController)
                              with:[self exchangeVC]];
//        [definition injectProperty:@selector(analyticHelper)
//                              with:[_helperAssembly analyticHelper]];
    }];
}

- (OSTExchangeVC *)exchangeVC
{
    return [TyphoonDefinition withClass:[OSTExchangeVC class]
                          configuration:^(TyphoonDefinition *definition)
    {
//        [definition injectProperty:@selector(hudHelper)
//                              with:[_helperAssembly hudHelper]];
    }];
}

@end
