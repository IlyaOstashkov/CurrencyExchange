
#import "TyphoonAssembly.h"

@protocol OSTHudHelper, OSTServerHelper;

@interface OSTHelperAssembly : TyphoonAssembly

- (id<OSTHudHelper>)hudHelper;
- (id<OSTServerHelper>)serverHelper;

@end
