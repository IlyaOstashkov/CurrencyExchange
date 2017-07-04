
#import "OSTExchangeVC.h"
// protocols
#import "OSTExchangeHelper.h"
// models
#import "OSTExchangeRate.h"

@interface OSTExchangeVC ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *firstPageControl;
@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UICollectionView *secondCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *secondPageControl;

@end

@implementation OSTExchangeVC

#pragma mark - View controller lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self defaultSetup];
    [self requestExchangeRateArray];
}

#pragma mark - Setup methods -

- (void)defaultSetup
{
    [self setupContentViewIsReadyForExchange:NO];
}

- (void)setupContentViewIsReadyForExchange:(BOOL)isReady
{
    _exchangeButton.hidden = !isReady;
    _firstCollectionView.hidden = !isReady;
    _firstPageControl.hidden = !isReady;
    _secondCollectionView.hidden = !isReady;
    _secondPageControl.hidden = !isReady;
}

#pragma mark - Refresh methods -



#pragma mark - Server methods -

- (void)requestExchangeRateArray
{
    [_activityIndicator startAnimating];
    [_exchangeHelper getExchangeRateArrayWithCompletion:^(NSArray *rateArray,
                                                          NSError *error)
     {
         [_activityIndicator stopAnimating];
         if (error || !rateArray.count)
         {
             //TODO: show error hud
         }
         else
         {
             [self setupContentViewIsReadyForExchange:YES];
             
             OSTExchangeRate *exchangeRate = rateArray[5];
             OSTCurrency currency = [exchangeRate currency];
             NSLog(@"%lu", (unsigned long)currency);
         }
     }];
}

#pragma mark - User interaction -

- (IBAction)exchangeButtonPressed:(UIButton *)sender
{
    
}

@end
