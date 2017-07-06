
@protocol OSTServerHelper, OSTHudHelper;

@interface OSTExchangeVC : UIViewController

@property (strong, nonatomic) id<OSTServerHelper> serverHelper;
@property (strong, nonatomic) id<OSTHudHelper> hudHelper;

@end
