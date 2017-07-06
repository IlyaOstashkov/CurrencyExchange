
#import "OSTExchangeVC.h"
// protocols
#import "OSTServerHelper.h"
#import "OSTHudHelper.h"
#import "OSTSecurityHelper.h"
// models
#import "OSTExchangeRate.h"
#import "OSTExchangeRateList.h"
// views
#import "OSTExchangeCollectionViewCell.h"

NSUInteger const kOSTRequestPerSeconds = 30;
NSUInteger const kOSTColletionViewPagesCount = 198;
double const kOSTDefaultValueToExchange = 10;

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
@property (nonatomic) NSUInteger requestTimeCounter;
@property (nonatomic) BOOL canRefreshColletionViews;

@property (strong, nonatomic) NSNumber *selectedFromValue;
@property (strong, nonatomic) OSTExchangeRate *selectedFromRate;

@property (strong, nonatomic) NSNumber *selectedToValue;
@property (strong, nonatomic) OSTExchangeRate *selectedToRate;

@end

@implementation OSTExchangeVC

#pragma mark - View controller lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self defaultSetup];
    [self refreshExchangeButton];
    [self requestExchangeRateArrayIsFirstTime:YES];
}

- (void)dealloc
{
    [self clearDelegateForCollectionView:_firstCollectionView];
    [self clearDelegateForCollectionView:_secondCollectionView];
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
    self.canRefreshColletionViews = YES;
    [self setupTapGestureRecognizer];
}

- (void)setupCollectionView:(UICollectionView *)collectionView
{
    NSString *collectionCellId = NSStringFromClass([OSTExchangeCollectionViewCell class]);
    [collectionView registerNib:[UINib nibWithNibName:collectionCellId bundle:nil]
     forCellWithReuseIdentifier:collectionCellId];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    // have to match currencyArray.firstObject
    NSUInteger index = kOSTColletionViewPagesCount / 2;
    // scroll to the middle
    [self scrollCollectionView:collectionView
                       toIndex:index];
}

- (void)setupContentViewIsReadyForExchange:(BOOL)isReady
{
    _exchangeButton.hidden = !isReady;
    _firstCollectionView.hidden = !isReady;
    _firstPageControl.hidden = !isReady;
    _secondCollectionView.hidden = !isReady;
    _secondPageControl.hidden = !isReady;
}

- (void)scrollCollectionView:(UICollectionView *)collectionView
                     toIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    [collectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                   animated:NO];
}

- (NSUInteger)exchangeRateArrayIndexForRow:(NSUInteger)row
{
    return row % _exchangeRateArray.count;
}

- (void)setupTapGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleTapFrom:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)clearDelegateForCollectionView:(UICollectionView *)collectionView
{
    collectionView.delegate = nil;
    collectionView.dataSource = nil;
}

#pragma mark - Refresh methods -

- (void)refreshCollectionViews
{
    if (_canRefreshColletionViews)
    {
        [_firstCollectionView reloadData];
        [_secondCollectionView reloadData];
    }
}

- (void)refreshContentViewWithDirectExchange:(BOOL)isDirectExchange
{
    double fromRate = [_selectedFromRate.rate doubleValue];
    double toRate = [_selectedToRate.rate doubleValue];
    if (isDirectExchange)
    {
        double fromValue = [_selectedFromValue doubleValue];
        double toValue = toRate * fromValue / fromRate;
        self.selectedToValue = @(toValue);
    }
    else
    {
        double toValue = [_selectedToValue doubleValue];
        double fromValue = fromRate * toValue / toRate;
        self.selectedFromValue = @(fromValue);
    }
    [self refreshCollectionViews];
    [self refreshExchangeButton];
}

- (void)refreshExchangeButton
{
    _exchangeButton.alpha = [self isExchangeAvailable] ? 1.f : .7f;
}

- (BOOL)isExchangeAvailable
{
    OSTCurrency currency = [_selectedFromRate currency];
    double account = [self getUserAccountWithCurrency:currency];
    double fromValue = [_selectedFromValue doubleValue];
    BOOL isEqualCurrencies = [_selectedFromRate currency] == [_selectedToRate currency];
    return account >= fromValue && !isEqualCurrencies;
}

#pragma mark - Server methods -

- (void)requestExchangeRateArrayIsFirstTime:(BOOL)isFirstTime
{
    [_activityIndicator startAnimating];
    _refreshButton.hidden = YES;
    [_serverHelper getExchangeRateListWithCompletion:^(OSTExchangeRateList *response,
                                                       NSError *error)
     {
         [self startRequestTimer];
         [_activityIndicator stopAnimating];
         if (error || !response.list.count)
         {
             NSString *message = [NSString stringWithFormat:@"Could not get actual exchange rates%@",
                                  isFirstTime ? @", try again later" : @""];
             [_hudHelper showWithMessage:message
                                    type:OSTHudTypeMessage];
             if (isFirstTime) {
                 _refreshButton.hidden = NO;
             }
         }
         else
         {
             [self setupContentViewIsReadyForExchange:YES];
             [self prepareExchangeRateArrayWithResponse:response];
             if (isFirstTime)
             {
                 self.selectedFromRate = _exchangeRateArray.firstObject;
                 self.selectedFromValue = @(kOSTDefaultValueToExchange);
                 self.selectedToRate = _selectedFromRate;
             }
             [self refreshContentViewWithDirectExchange:YES];
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
}

#pragma mark - Work with user accounts -

- (double)getUserAccountWithCurrency:(OSTCurrency)currency
{
    NSString *key;
    switch (currency)
    {
        case OSTCurrencyEUR:
            key = kOSTSecureKeyEurAccount;
            break;
            
        case OSTCurrencyUSD:
            key = kOSTSecureKeyUsdAccount;
            break;
            
        case OSTCurrencyGBP:
            key = kOSTSecureKeyGbpAccount;
            break;
            
        default:
            return 0;
    }
    NSString *userAccountString = [_securityHelper stringForKey:key];
    return [userAccountString doubleValue];
}

#pragma mark - User interaction -

- (IBAction)exchangeButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)refreshButtonPressed:(UIButton *)sender
{
    [self requestExchangeRateArrayIsFirstTime:YES];
}

- (void)handleTapFrom:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Timer methods -

- (void)startRequestTimer
{
    self.requestTimeCounter = kOSTRequestPerSeconds;
    [self requestTimerTick];
}

- (void)requestTimerTick
{
    /**
     I want to show the work with GCD and recursion here.
     But also I can perform periodic request with NSTimer.
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^
    {
        if (_requestTimeCounter == 0)
        {
            [self requestExchangeRateArrayIsFirstTime:NO];
            return;
        }
        self.requestTimeCounter--;
        [self requestTimerTick];
    });
}

#pragma mark - UICollectionView methods -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return kOSTColletionViewPagesCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = NSStringFromClass([OSTExchangeCollectionViewCell class]);
    OSTExchangeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                                    forIndexPath:indexPath];
    OSTExchangeRate *rate = _exchangeRateArray[[self exchangeRateArrayIndexForRow:indexPath.row]];
    BOOL isEqualCurrencies = [_selectedFromRate currency] == [_selectedToRate currency];
    double account = [self getUserAccountWithCurrency:[rate currency]];
    __weak typeof(self) weakSelf = self;
    if (collectionView == _firstCollectionView)
    {
        [cell configureWithAccount:account
                             value:[_selectedFromValue doubleValue]
                          mainRate:rate
                    additionalRate:nil
                       isShowValue:!isEqualCurrencies
       valueBeginEditingCompletion:^
        {
            weakSelf.canRefreshColletionViews = NO;
        }
            valueChangedCompletion:^(double value)
        {
            weakSelf.selectedFromValue = @(value);
            weakSelf.canRefreshColletionViews = YES;
            [weakSelf refreshContentViewWithDirectExchange:YES];
        }];
    }
    else if (collectionView == _secondCollectionView)
    {
        [cell configureWithAccount:account
                             value:[_selectedToValue doubleValue]
                          mainRate:rate
                    additionalRate:!isEqualCurrencies ? _selectedFromRate : nil
                       isShowValue:!isEqualCurrencies
       valueBeginEditingCompletion:^
         {
             weakSelf.canRefreshColletionViews = NO;
         }
            valueChangedCompletion:^(double value)
         {
             weakSelf.selectedToValue = @(value);
             weakSelf.canRefreshColletionViews = YES;
             [weakSelf refreshContentViewWithDirectExchange:NO];
         }];
    }
    
    return cell;
}

#pragma mark - UIScrollVewDelegate -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width + 0.5;
    currentIndex = [self exchangeRateArrayIndexForRow:currentIndex];
    if (scrollView == _firstCollectionView)
    {
        _firstPageControl.currentPage = currentIndex;
        self.selectedFromRate = _exchangeRateArray[currentIndex];
        self.selectedFromValue = @(kOSTDefaultValueToExchange);
    }
    else if (scrollView == _secondCollectionView)
    {
        _secondPageControl.currentPage = currentIndex;
        self.selectedToRate = _exchangeRateArray[currentIndex];
        self.selectedToValue = @(kOSTDefaultValueToExchange);
    }
    [self refreshContentViewWithDirectExchange:YES];
}

@end
