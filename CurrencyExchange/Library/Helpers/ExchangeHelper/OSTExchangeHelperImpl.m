
#import "OSTExchangeHelperImpl.h"
// protocols
#import "OSTServerHelper.h"
// models
#import "OSTExchangeRateList.h"

NSUInteger const kOSTRequestPerSeconds = 30;

@interface OSTExchangeHelperImpl ()

@property (strong, nonatomic) OSTExchangeRateList *rateList; // last cache of rate list
@property (nonatomic) NSUInteger requestTimeCounter;

@end

@implementation OSTExchangeHelperImpl

#pragma mark - Public methods -

- (void)getExchangeRateListWithCompletion:(OSTExchangeHelperRateListCompletion)completion
{
    if (_rateList.list.count)
    {
        // return last cache
        completion(_rateList, nil);
    }
    else
    {
        // first request
        [self requestExchangeRateListWithCompletion:completion];
    }
}

#pragma mark - Server methods -

- (void)requestExchangeRateListWithCompletion:(OSTExchangeHelperRateListCompletion)completion
{
    [_serverHelper getExchangeRateListWithCompletion:^(OSTExchangeRateList *response,
                                                       NSError *error)
     {
         self.rateList = response;
         [self startRequestTimer];
         if (completion) {
             completion(_rateList, error);
         }
     }];
}

#pragma mark - Timer methods -

- (void)startRequestTimer
{
    self.requestTimeCounter = kOSTRequestPerSeconds;
    [self requestTimerTick];
}

- (void)requestTimerTick
{
    /**
     I want to show work with GCD and recursion here. 
     But also I can perform periodic request with NSTimer.
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^
    {
        if (_requestTimeCounter == 0)
        {
            [self requestExchangeRateListWithCompletion:nil];
            return;
        }
        self.requestTimeCounter--;
        [self requestTimerTick];
    });
}

@end
