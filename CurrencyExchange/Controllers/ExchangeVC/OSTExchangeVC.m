
#import "OSTExchangeVC.h"
// protocols
#import "OSTExchangeHelper.h"
#import "OSTHudHelper.h"
// models
#import "OSTExchangeRate.h"
#import "OSTExchangeRateList.h"
// views
#import "OSTExchangeCollectionViewCell.h"

@interface OSTExchangeVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *firstCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *firstPageControl;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UICollectionView *secondCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *secondPageControl;

@property (strong, nonatomic) NSArray *currencyArray;
@property (strong, nonatomic) NSMutableArray *exchangeRateArray;

@property (strong, nonatomic) OSTExchangeRate *selectedFromRate;
@property (strong, nonatomic) OSTExchangeRate *selectedToRate;

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
    self.currencyArray = @[@(OSTCurrencyEUR),
                           @(OSTCurrencyUSD),
                           @(OSTCurrencyGBP)];
    [self setupContentViewIsReadyForExchange:NO];
    [self setupCollectionView:_firstCollectionView];
    [self setupCollectionView:_secondCollectionView];
}

- (void)setupCollectionView:(UICollectionView *)collectionView
{
    NSString *collectionCellId = NSStringFromClass([OSTExchangeCollectionViewCell class]);
    [collectionView registerNib:[UINib nibWithNibName:collectionCellId bundle:nil]
     forCellWithReuseIdentifier:collectionCellId];
    collectionView.delegate = self;
    collectionView.dataSource = self;
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

- (void)refreshCollectionViews
{
    [_firstCollectionView reloadData];
    [_secondCollectionView reloadData];
}

#pragma mark - Server methods -

- (void)requestExchangeRateArray
{
    [_activityIndicator startAnimating];
    _refreshButton.hidden = YES;
    [_exchangeHelper getExchangeRateListWithCompletion:^(OSTExchangeRateList *rateList,
                                                         NSError *error)
     {
         [_activityIndicator stopAnimating];
         if (error || !rateList.list.count)
         {
             _refreshButton.hidden = NO;
             [_hudHelper showWithMessage:@"Could not get exchange rates, try again later"
                                    type:OSTHudTypeMessage];
         }
         else
         {
             [self setupContentViewIsReadyForExchange:YES];
             [self prepareExchangeRateArrayWithResponse:rateList];
             [self refreshCollectionViews];
         }
     }];
}

- (void)prepareExchangeRateArrayWithResponse:(OSTExchangeRateList *)response
{
    self.exchangeRateArray = [NSMutableArray new];
    for (NSNumber *currencyNumber in _currencyArray)
    {
        OSTCurrency currency = [currencyNumber integerValue];
        switch (currency)
        {
            case OSTCurrencyEUR:
            {
                OSTExchangeRate *eurRate = [OSTExchangeRate new];
                eurRate.currencyString = @"EUR";
                eurRate.rate = @1;
                [_exchangeRateArray addObject:eurRate];
                break;
            }
                
            default:
            {
                OSTExchangeRate *rate = [response getExchangeRateWithCurrency:currency];
                [_exchangeRateArray addObject:rate];
                break;
            }
        }
    }
    
    // by default
    self.selectedFromRate = _exchangeRateArray.firstObject;
    self.selectedToRate = _exchangeRateArray.firstObject;
}

#pragma mark - User interaction -

- (IBAction)exchangeButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)refreshButtonPressed:(UIButton *)sender
{
    [self requestExchangeRateArray];
}

#pragma mark - UICollectionView methods -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return _exchangeRateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = NSStringFromClass([OSTExchangeCollectionViewCell class]);
    OSTExchangeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                                    forIndexPath:indexPath];
    OSTExchangeRate *rate = _exchangeRateArray[indexPath.row];
    BOOL isEqualCurrencies = [_selectedFromRate currency] == [_selectedToRate currency];
    if (collectionView == _firstCollectionView)
    {
        [cell configureWithMainRate:rate
                     additionalRate:nil
                        isShowValue:!isEqualCurrencies];
    }
    else if (collectionView == _secondCollectionView)
    {
        [cell configureWithMainRate:rate
                     additionalRate:!isEqualCurrencies ? _selectedFromRate : nil
                        isShowValue:!isEqualCurrencies];
    }
    
    return cell;
}

#pragma mark - UIScrollVewDelegate -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width + 0.5;
    NSLog(@"page = %ld", (long)currentIndex);
    if (scrollView == _firstCollectionView)
    {
        _firstPageControl.currentPage = currentIndex;
        self.selectedFromRate = _exchangeRateArray[currentIndex];
    }
    else if (scrollView == _secondCollectionView)
    {
        _secondPageControl.currentPage = currentIndex;
        self.selectedToRate = _exchangeRateArray[currentIndex];
    }
    [self refreshCollectionViews];
}

@end
