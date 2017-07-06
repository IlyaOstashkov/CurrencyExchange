
#import "OSTHelperAssembly.h"
// protocols
#import "OSTHudHelper.h"
#import "OSTServerHelper.h"
#import "OSTSecurityHelper.h"
// implementations
#import "OSTHudHelperImpl.h"
#import "OSTServerHelperImpl.h"
#import "OSTSecurityHelperImpl.h"

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

- (id<OSTSecurityHelper>)securityHelper
{
    return [TyphoonDefinition withClass:[OSTSecurityHelperImpl class]
                          configuration:^(TyphoonDefinition *definition)
    {
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end
