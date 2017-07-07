
typedef NS_ENUM(NSInteger, OSTHudType) {
    OSTHudTypeProcess,
    OSTHudTypeSuccess,
    OSTHudTypeError,
    OSTHudTypeMessage,
    OSTHudTypeBlock
};

/**
 It helps to show and hide huds
 */
@protocol OSTHudHelper <NSObject>

/**
 Show hud with message
 */
- (void)showWithMessage:(NSString *)message
                   type:(OSTHudType)type;

/**
 Show hud with parent view and message
 */
- (void)showWithParentView:(UIView *)parentView
                   message:(NSString *)message
                      type:(OSTHudType)type;

/**
 Hide current hud
 */
- (void)hide;

@end
