
@class OSTExchangeRateList;

typedef void (^OSTExchangeHelperRateListCompletion)(OSTExchangeRateList *rateList, NSError *error);

@protocol OSTExchangeHelper <NSObject>

/**
 Get current exchange rate list
 */
- (void)getExchangeRateListWithCompletion:(OSTExchangeHelperRateListCompletion)completion;

@end
