
#import "OSTHelperAssembly.h"
// protocols
#import "OSTHudHelper.h"
#import "OSTServerHelper.h"
// implementations
#import "OSTHudHelperImpl.h"
#import "OSTServerHelperImpl.h"

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

@end
