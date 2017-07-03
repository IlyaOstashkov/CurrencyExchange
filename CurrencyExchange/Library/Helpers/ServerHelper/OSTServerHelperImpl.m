
#import "OSTServerHelperImpl.h"
// models
#import "OSTExchangeRateList.h"
// vendors
#import "AFNetworkActivityIndicatorManager.h"

// urls
NSString * const kOSTUrlExchangeRates = @"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml";

@implementation OSTServerHelperImpl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

#pragma mark - OSTAServerHelper protocol -

- (void)getExchangeRatesWithCompletion:(OSTServerHelperArrayCompletionBlock)completion
{
    if (!completion) {
        return;
    }
    [self GET:kOSTUrlExchangeRates
   parameters:nil
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task,
                id  _Nullable responseObject)
     {
         NSError *error;
         OSTExchangeRateList *rateList = [MXEXmlAdapter modelOfClass:[OSTExchangeRateList class]
                                                         fromXmlData:responseObject
                                                               error:&error];
         completion(rateList.list, nil);
     }
      failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error)
     {
         completion(nil, error);
     }];
}

@end
