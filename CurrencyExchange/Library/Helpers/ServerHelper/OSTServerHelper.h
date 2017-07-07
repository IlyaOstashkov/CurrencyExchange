
typedef void (^OSTServerHelperCompletion)(id response, NSError *error);

/**
 It helps to make requests to the API
 */
@protocol OSTServerHelper <NSObject>

/**
 Get current exchange rate list or error
 */
- (void)getExchangeRateListWithCompletion:(OSTServerHelperCompletion)completion;

@end
