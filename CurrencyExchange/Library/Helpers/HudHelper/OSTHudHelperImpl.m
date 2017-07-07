
#import "OSTHudHelperImpl.h"

// vendors
#import "MBProgressHUD.h"

@interface OSTHudHelperImpl () <MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD *currentHUD;

@end

@implementation OSTHudHelperImpl

#pragma mark - OSTAHudHelper protocol -

- (void)showWithMessage:(NSString *)message
                   type:(OSTHudType)type
{
    return [self showWithParentView:[UIApplication sharedApplication].keyWindow
                            message:message
                               type:type];
}

- (void)showWithParentView:(UIView *)parentView
                   message:(NSString *)message
                      type:(OSTHudType)type
{
    if (!parentView) {
        parentView = [UIApplication sharedApplication].keyWindow;
    }
    
    [self hide];
    
    self.currentHUD = [MBProgressHUD showHUDAddedTo:parentView
                                           animated:YES];
    _currentHUD.label.text = nil;
    _currentHUD.detailsLabel.text = message.length ? message : @"";
    
    _currentHUD.userInteractionEnabled = NO;
    double hideAfterDelay = 2.f;
    
    switch (type)
    {
        case OSTHudTypeError:
        {
            _currentHUD.customView = [[UIImageView alloc] initWithImage:
                                      [UIImage imageNamed:@"common-cross"]];
            _currentHUD.mode = MBProgressHUDModeCustomView;
            [_currentHUD hideAnimated:YES
                           afterDelay:hideAfterDelay];
            break;
        }
            
        case OSTHudTypeSuccess:
        {
            _currentHUD.customView = [[UIImageView alloc] initWithImage:
                                      [UIImage imageNamed:@"common-accept"]];
            _currentHUD.mode = MBProgressHUDModeCustomView;
            [_currentHUD hideAnimated:YES
                           afterDelay:hideAfterDelay];
            break;
        }
            
        case OSTHudTypeProcess:
        {
            _currentHUD.userInteractionEnabled = YES;
            break;
        }
            
        case OSTHudTypeBlock:
        {
            _currentHUD.mode = MBProgressHUDModeText;
            _currentHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            _currentHUD.backgroundView.color = [UIColor colorWithWhite:0.f
                                                                 alpha:.2f];
            [_currentHUD hideAnimated:YES
                           afterDelay:hideAfterDelay];
            break;
        }
            
        case OSTHudTypeMessage:
        {
            _currentHUD.mode = MBProgressHUDModeText;
            [_currentHUD hideAnimated:YES
                           afterDelay:hideAfterDelay];
            break;
        }
            
        default:
            break;
    }
}

- (void)hide
{    
    if (_currentHUD) {
        [_currentHUD hideAnimated:YES];
        self.currentHUD = nil;
    }
}

@end
