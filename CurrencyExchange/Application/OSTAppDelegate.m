
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


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    NSString *eurAccount = [_securityHelper stringForKey:key];
    if (!eurAccount.length) {
        [_securityHelper saveString:[NSString stringWithFormat:@"%f", value]
                             forKey:key];
    }
}

@end
