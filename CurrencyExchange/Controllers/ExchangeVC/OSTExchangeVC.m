
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_exchangeHelper getExchangeRateArrayWithCompletion:^(NSArray *rateArray,
                                                          NSError *error)
    {
        OSTExchangeRate *exchangeRate = rateArray[5];
        OSTCurrency currency = [exchangeRate currency];
        NSLog(@"%lu", (unsigned long)currency);
    }];
}

#pragma mark - User interaction -

- (IBAction)exchangeButtonPressed:(UIButton *)sender
{
    
}

@end
