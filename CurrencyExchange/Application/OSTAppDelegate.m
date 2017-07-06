
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
    // window initialization here (not in Typhoon assembly) because it depends on orientation changing
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.rootViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setupUserAccountsIfNeeded];
    
    return YES;
}

#pragma mark - Setup methods -

- (void)setupUserAccountsIfNeeded
{
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
