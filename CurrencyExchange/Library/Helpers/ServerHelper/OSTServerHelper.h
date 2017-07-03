
typedef void (^OSTServerHelperArrayCompletionBlock)(NSArray *response, NSError *error);

@protocol OSTServerHelper <NSObject>

/**
 Get current exchange rates
 */
- (void)getExchangeRatesWithCompletion:(OSTServerHelperArrayCompletionBlock)completion;

@end
