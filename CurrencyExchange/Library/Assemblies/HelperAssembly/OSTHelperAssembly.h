
#import "TyphoonAssembly.h"

@protocol OSTHudHelper, OSTServerHelper, OSTSecurityHelper;

@interface OSTHelperAssembly : TyphoonAssembly

- (id<OSTHudHelper>)hudHelper;
- (id<OSTServerHelper>)serverHelper;
- (id<OSTSecurityHelper>)securityHelper;

@end
