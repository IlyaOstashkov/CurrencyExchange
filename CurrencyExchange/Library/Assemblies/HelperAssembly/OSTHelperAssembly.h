
#import "TyphoonAssembly.h"

@class OSTAppAssembly;

@protocol OSTHudHelper;

@interface OSTHelperAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) OSTAppAssembly *appAssembly;

- (id<OSTHudHelper>)hudHelper;

@end
