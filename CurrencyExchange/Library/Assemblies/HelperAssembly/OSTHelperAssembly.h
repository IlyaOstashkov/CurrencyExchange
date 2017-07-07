
#import "TyphoonAssembly.h"

@protocol OSTHudHelper, OSTServerHelper, OSTSecurityHelper;

/**
 Dependency injection assembly. It works as a factory of helpers
 */
@interface OSTHelperAssembly : TyphoonAssembly

/**
 It helps to show and hide huds
 */
- (id<OSTHudHelper>)hudHelper;

/**
 It helps to make requests to the API
 */
- (id<OSTServerHelper>)serverHelper;

/**
 It helps to store strings securely
 */
- (id<OSTSecurityHelper>)securityHelper;

@end
