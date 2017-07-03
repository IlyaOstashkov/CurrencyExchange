
#import "OSTExchangeHelperImpl.h"
// protocols
#import "OSTServerHelper.h"

NSUInteger const kOSTRequestPerSeconds = 10;

@interface OSTExchangeHelperImpl ()

@property (strong, nonatomic) NSArray *rateArray; // last cache of rate array
@property (nonatomic) NSUInteger requestTimeCounter;

@end

@implementation OSTExchangeHelperImpl

- (void)getExchangeRateArrayWithCompletion:(OSTExchangeHelperRateArrayCompletion)completion
{
    if (_rateArray.count)
    {
        // return last cache
        completion(_rateArray, nil);
    }
    else
    {
        // first request
        [self requestExchangeRateArrayWithCompletion:completion];
    }
}

#pragma mark - Server methods -

- (void)requestExchangeRateArrayWithCompletion:(OSTExchangeHelperRateArrayCompletion)completion
{
    [_serverHelper getExchangeRateArrayWithCompletion:^(NSArray *response,
                                                        NSError *error)
     {
         self.rateArray = response;
         [self startRequestTimer];
         if (completion) {
             completion(_rateArray, error);
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
            [self requestExchangeRateArrayWithCompletion:nil];
            return;
        }
        self.requestTimeCounter--;
        [self requestTimerTick];
    });
}

@end
