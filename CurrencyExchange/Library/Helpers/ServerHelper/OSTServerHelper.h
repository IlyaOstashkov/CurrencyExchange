
typedef void (^OSTServerHelperCompletion)(id response, NSError *error);

@protocol OSTServerHelper <NSObject>

/**
 Get current exchange rate list or error
 */
- (void)getExchangeRateListWithCompletion:(OSTServerHelperCompletion)completion;

@end
