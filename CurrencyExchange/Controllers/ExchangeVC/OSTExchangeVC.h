
@protocol OSTServerHelper, OSTHudHelper, OSTSecurityHelper;

@interface OSTExchangeVC : UIViewController

// properties for dependency injections
@property (strong, nonatomic) id<OSTServerHelper> serverHelper;
@property (strong, nonatomic) id<OSTHudHelper> hudHelper;
@property (strong, nonatomic) id<OSTSecurityHelper> securityHelper;

@end
