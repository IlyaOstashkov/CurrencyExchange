
@protocol OSTSecurityHelper;

@interface OSTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *rootViewController;
@property (strong, nonatomic) id<OSTSecurityHelper> securityHelper;

@end

