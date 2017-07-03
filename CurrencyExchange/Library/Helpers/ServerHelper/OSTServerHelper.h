
typedef void (^OSTServerHelperArrayCompletion)(NSArray *response, NSError *error);

@protocol OSTServerHelper <NSObject>

/**
 Get current exchange rate array
 */
- (void)getExchangeRateArrayWithCompletion:(OSTServerHelperArrayCompletion)completion;

@end
