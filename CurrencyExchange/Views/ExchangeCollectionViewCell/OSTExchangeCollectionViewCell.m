
#import "OSTExchangeCollectionViewCell.h"
// models
#import "OSTExchangeRate.h"

@interface OSTExchangeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

@end

@implementation OSTExchangeCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Public methods -

- (void)configureWithMainRate:(OSTExchangeRate *)mainRate
               additionalRate:(OSTExchangeRate *)additionalRate
                  isShowValue:(BOOL)isShowValue
{
    _currencyLabel.text = [mainRate.currencyString uppercaseString];
    
    _valueTextField.enabled = isShowValue;
    
    if (mainRate && additionalRate)
    {
        NSString *rateFormat = @"%@1 = %@%.2f";
        double rate = [additionalRate.rate doubleValue] / [mainRate.rate doubleValue];
        _helpLabel.text = [NSString stringWithFormat:rateFormat,
                           [mainRate currencySymbol],
                           [additionalRate currencySymbol],
                           rate];
    }
    
    // some animations
    [UIView animateWithDuration:0.2
                     animations:^
     {
         _valueTextField.alpha = isShowValue ? 1.f : 0;
         _helpLabel.alpha = additionalRate ? 1.f : 0;
     }];
}

@end
