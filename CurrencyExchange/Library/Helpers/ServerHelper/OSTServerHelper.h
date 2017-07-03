
typedef void (^OSTServerHelperCompletionBlock)(id response, NSError *error);

@protocol OSTServerHelper <NSObject>

/**
 Get current exchange rates
 */
- (void)getExchangeRatesWithCompletion:(OSTServerHelperCompletionBlock)completion;

@end
