
// protocol
#import "OSTExchangeHelper.h"

@protocol OSTServerHelper;

@interface OSTExchangeHelperImpl : NSObject <OSTExchangeHelper>

@property (strong, nonatomic) id<OSTServerHelper> serverHelper;

@end
