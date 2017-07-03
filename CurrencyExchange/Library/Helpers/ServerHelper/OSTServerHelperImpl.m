
#import "OSTServerHelperImpl.h"
// vendors
#import "AFNetworkActivityIndicatorManager.h"

// urls
NSString * const kOSTUrlExchangeRates = @"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml";

@implementation OSTServerHelperImpl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

#pragma mark - OSTAServerHelper protocol -

- (void)getExchangeRatesWithCompletion:(OSTServerHelperCompletionBlock)completion
{
    [self GET:kOSTUrlExchangeRates
   parameters:nil
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
//         NSError *error;
//         id response = [MTLJSONAdapter modelOfClass:[OSTAAdmob class]
//                                 fromJSONDictionary:responseObject
//                                              error:&error];
//         completion(response, nil);
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         completion(nil, error);
     }];
}

@end
