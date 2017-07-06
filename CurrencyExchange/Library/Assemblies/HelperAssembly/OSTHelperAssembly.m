
#import "OSTHelperAssembly.h"
// protocols
#import "OSTHudHelper.h"
#import "OSTServerHelper.h"
#import "OSTExchangeHelper.h"
// implementations
#import "OSTHudHelperImpl.h"
#import "OSTServerHelperImpl.h"
#import "OSTExchangeHelperImpl.h"

@implementation OSTHelperAssembly

- (id<OSTHudHelper>)hudHelper;
{
    return [TyphoonDefinition withClass:[OSTHudHelperImpl class]
                          configuration:^(TyphoonDefinition *definition)
    {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id<OSTServerHelper>)serverHelper;
{
    return [TyphoonDefinition withClass:[OSTServerHelperImpl class]
                          configuration:^(TyphoonDefinition *definition)
    {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id<OSTExchangeHelper>)exchangeHelper;
{
    return [TyphoonDefinition withClass:[OSTExchangeHelperImpl class]
                          configuration:^(TyphoonDefinition *definition)
    {
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end
