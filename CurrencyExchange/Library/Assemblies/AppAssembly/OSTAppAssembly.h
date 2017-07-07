
#import "TyphoonAssembly.h"

@class OSTHelperAssembly, OSTExchangeVC;

/**
 Dependency injection assembly. It works as a factory of view controllers
 */
@interface OSTAppAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) OSTHelperAssembly *helperAssembly;

#pragma mark - Controllers -

- (OSTExchangeVC *)exchangeVC;

@end
