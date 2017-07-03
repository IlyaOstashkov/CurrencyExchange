
typedef void (^OSTExchangeHelperRateArrayCompletion)(NSArray *rateArray, NSError *error);

@protocol OSTExchangeHelper <NSObject>

/**
 Get current exchange rate array
 */
- (void)getExchangeRateArrayWithCompletion:(OSTExchangeHelperRateArrayCompletion)completion;

@end
