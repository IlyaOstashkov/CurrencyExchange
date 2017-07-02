
#import "OSTHelperAssembly.h"
// protocols
#import "OSTHudHelper.h"
// implementations
#import "OSTHudHelperImpl.h"

@implementation OSTHelperAssembly

- (id<OSTHudHelper>)hudHelper;
{
    return [TyphoonDefinition withClass:[OSTHudHelperImpl class]
                          configuration:^(TyphoonDefinition *definition)
    {
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end
