
@protocol OSTExchangeHelper, OSTHudHelper;

@interface OSTExchangeVC : UIViewController

@property (strong, nonatomic) id<OSTExchangeHelper> exchangeHelper;
@property (strong, nonatomic) id<OSTHudHelper> hudHelper;

@end
