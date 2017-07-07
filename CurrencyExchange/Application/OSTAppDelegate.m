
#import "OSTAppDelegate.h"
// protocols
#import "OSTSecurityHelper.h"

@interface OSTAppDelegate ()

@end

@implementation OSTAppDelegate

#pragma mark - Application lifecycle -

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    
    [self setupUserAccountsIfNeeded];
    
    return YES;
}

#pragma mark - Setup methods -

- (void)setupUserAccountsIfNeeded
{
    // set default values for user accounts
    [self setupUserAccountWithKey:kOSTSecureKeyEurAccount
                        withValue:100.f];
    [self setupUserAccountWithKey:kOSTSecureKeyUsdAccount
                        withValue:100.f];
    [self setupUserAccountWithKey:kOSTSecureKeyGbpAccount
                        withValue:100.f];
}

- (void)setupUserAccountWithKey:(NSString *)key
                      withValue:(double)value
{
    NSString *userAccount = [_securityHelper stringForKey:key];
    if (!userAccount.length) {
        [_securityHelper saveString:[NSString stringWithFormat:@"%f", value]
                             forKey:key];
    }
}

@end
