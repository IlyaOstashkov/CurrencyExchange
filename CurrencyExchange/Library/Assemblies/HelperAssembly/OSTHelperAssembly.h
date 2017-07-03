
#import "TyphoonAssembly.h"

@protocol OSTHudHelper, OSTServerHelper, OSTExchangeHelper;

@interface OSTHelperAssembly : TyphoonAssembly

- (id<OSTHudHelper>)hudHelper;
- (id<OSTServerHelper>)serverHelper;
- (id<OSTExchangeHelper>)exchangeHelper;

@end
