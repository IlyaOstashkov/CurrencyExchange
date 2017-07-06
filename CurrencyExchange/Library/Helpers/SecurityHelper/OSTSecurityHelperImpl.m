
#import "OSTSecurityHelperImpl.h"
// vendors
#import <SAMKeychain.h>

// keys
NSString * const kOSTSecureKeyEurAccount = @"eur-account";
NSString * const kOSTSecureKeyUsdAccount = @"usd-account";
NSString * const kOSTSecureKeyGbpAccount = @"gbp-account";

@implementation OSTSecurityHelperImpl

#pragma mark - Public methods -

- (NSString *)stringForKey:(NSString *)key
{
    if (!key.length) {
        return nil;
    }
    return [SAMKeychain passwordForService:key
                                   account:[self bundleIdentifier]];
}

- (void)saveString:(NSString *)string
            forKey:(NSString *)key
{
    if (!key.length) {
        return;
    }
    [SAMKeychain setPassword:string
                  forService:key
                     account:[self bundleIdentifier]];
}

#pragma mark - Private methods -

- (NSString *)bundleIdentifier
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

@end
