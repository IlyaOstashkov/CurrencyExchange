
#import "TyphoonAssembly.h"

@protocol OSTHudHelper, OSTServerHelper, OSTExchangeHelper, OSTSecurityHelper;

@interface OSTHelperAssembly : TyphoonAssembly

- (id<OSTHudHelper>)hudHelper;
- (id<OSTServerHelper>)serverHelper;
- (id<OSTExchangeHelper>)exchangeHelper;
- (id<OSTSecurityHelper>)securityHelper;

@end
