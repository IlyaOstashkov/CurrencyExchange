
#import "OSTExchangeCollectionViewCell.h"
// models
#import "OSTExchangeRate.h"

@interface OSTExchangeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLabel;

@end

@implementation OSTExchangeCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)configureWithExchangeRate:(OSTExchangeRate *)exchangeRate
{
    _currencyLabel.text = [exchangeRate.currencyString uppercaseString];
}

@end
