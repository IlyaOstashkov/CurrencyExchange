
#import "TyphoonAssembly.h"

@class OSTHelperAssembly, OSTExchangeVC;

@interface OSTAppAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) OSTHelperAssembly *helperAssembly;

#pragma mark - Controllers -

- (OSTExchangeVC *)exchangeVC;

@end
