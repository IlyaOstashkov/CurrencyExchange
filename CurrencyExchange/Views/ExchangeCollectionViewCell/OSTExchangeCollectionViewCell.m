
#import "OSTExchangeCollectionViewCell.h"
// models
#import "OSTExchangeRate.h"

NSString * const kOSTPrefixPlus = @"+ ";
NSString * const kOSTPrefixMinus = @"- ";

@interface OSTExchangeCollectionViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

@property (nonatomic) BOOL isShowPlusPrefix;

@end

@implementation OSTExchangeCollectionViewCell

#pragma mark - View lifecycle -

- (void)awakeFromNib
{
    [super awakeFromNib];
    _valueTextField.delegate = self;
}

#pragma mark - Public methods -

- (void)configureWithMainRate:(OSTExchangeRate *)mainRate
               additionalRate:(OSTExchangeRate *)additionalRate
                  isShowValue:(BOOL)isShowValue
{
    self.isShowPlusPrefix = additionalRate ? YES : NO;
    
    _currencyLabel.text = [mainRate.currencyString uppercaseString];
    
    _valueTextField.enabled = isShowValue;
    NSString *valuePrefix = _isShowPlusPrefix ? kOSTPrefixPlus : kOSTPrefixMinus;
    _valueTextField.text = [NSString stringWithFormat:@"%@%@", valuePrefix, @534.20]; //for test
    
    double mainRateDouble = [mainRate.rate doubleValue];
    if (additionalRate &&
        mainRateDouble != 0)
    {
        NSString *rateFormat = @"%@1 = %@%.2f";
        double rateDouble = [additionalRate.rate doubleValue] / mainRateDouble;
        _helpLabel.text = [NSString stringWithFormat:rateFormat,
                           [mainRate currencySymbol],
                           [additionalRate currencySymbol],
                           rateDouble];
    }
    
    // some animations
    [UIView animateWithDuration:0.2
                     animations:^
     {
         _valueTextField.alpha = isShowValue ? 1.f : 0;
         _helpLabel.alpha = additionalRate ? 1.f : 0;
     }];
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *aNewText = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:string];
    NSString *valuePrefix = _isShowPlusPrefix ? kOSTPrefixPlus : kOSTPrefixMinus;
    return [aNewText hasPrefix:valuePrefix];
}

@end
