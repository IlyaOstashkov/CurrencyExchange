
#import "OSTExchangeCollectionViewCell.h"
// models
#import "OSTExchangeRate.h"

NSString * const kOSTPrefixPlus = @"+ ";
NSString * const kOSTPrefixMinus = @"- ";

NSString * const kOSTComma = @",";
NSString * const kOSTDot = @".";

@interface OSTExchangeCollectionViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

@property (strong, nonatomic) OSTExchangeValueChangedCompletion valueChangedCompletion;
@property (nonatomic) BOOL isShowPlusPrefix;

@end

@implementation OSTExchangeCollectionViewCell

#pragma mark - View lifecycle -

- (void)awakeFromNib
{
    [super awakeFromNib];
    _valueTextField.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleTapFrom:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)dealloc
{
    self.valueChangedCompletion = nil;
}

#pragma mark - Public methods -

- (void)configureWithMainRate:(OSTExchangeRate *)mainRate
               additionalRate:(OSTExchangeRate *)additionalRate
                  isShowValue:(BOOL)isShowValue
       valueChangedCompletion:(OSTExchangeValueChangedCompletion)valueChangedCompletion
{
    self.valueChangedCompletion = valueChangedCompletion;
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

#pragma mark - User interaction -

- (void)handleTapFrom:(id)sender
{
    [self endEditing:YES];
}

#pragma mark - Work with strings -

- (BOOL)checkDecimalInString:(NSString *)string
               withSeparator:(NSString *)separator
{
    if ([string containsString:separator])
    {
        NSArray *components = [string componentsSeparatedByString:separator];
        if([components count] >= 2)
        {
            NSString *decimalPart = [NSString stringWithFormat:@"%@", [components objectAtIndex:1]];
            return !([decimalPart length] > 2);
        }
    }
    return YES;
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range
                                                                  withString:string];
    NSString *valuePrefix = _isShowPlusPrefix ? kOSTPrefixPlus : kOSTPrefixMinus;
    if (![newString hasPrefix:valuePrefix]) {
        return NO;
    }
    
    NSString *oldString = textField.text;
    if ([string isEqualToString:kOSTComma] &&
        ([oldString containsString:kOSTComma] ||
         [oldString containsString:kOSTDot])) {
        return NO;
    }
    
    NSString *oldStringWithoutPrefix = [oldString substringFromIndex:kOSTPrefixPlus.length];
    if ([oldStringWithoutPrefix isEqualToString:@"0"] &&
        ![string isEqualToString:kOSTComma] &&
        ![string isEqualToString:@""]) {
        return NO;
    }
    
    NSString *newStringWithoutPrefix = [newString substringFromIndex:kOSTPrefixPlus.length];
    if ([newStringWithoutPrefix hasPrefix:kOSTComma]) {
        return NO;
    }
    
    if (newStringWithoutPrefix.length > 6) {
        return NO;
    }
    
    if (![self checkDecimalInString:newStringWithoutPrefix withSeparator:kOSTDot] ||
        ![self checkDecimalInString:newStringWithoutPrefix withSeparator:kOSTComma]) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text = textField.text;
    text = [text stringByReplacingOccurrencesOfString:kOSTComma
                                           withString:kOSTDot];
    
    if ([text hasSuffix:@"."]) {
        text = [text substringToIndex:text.length - 1];
    }
    
    NSCharacterSet *decimalDigitCharSet = [NSCharacterSet decimalDigitCharacterSet];
    // if new text doesn't contains digits then set 0
    if ([text rangeOfCharacterFromSet:decimalDigitCharSet].location == NSNotFound)
    {
        NSString *valuePrefix = _isShowPlusPrefix ? kOSTPrefixPlus : kOSTPrefixMinus;
        text = [NSString stringWithFormat:@"%@0", valuePrefix];
    }
    textField.text = text;
    
    if (_valueChangedCompletion)
    {
        NSString *stringWithoutPrefix = [text substringFromIndex:kOSTPrefixPlus.length];
        _valueChangedCompletion([stringWithoutPrefix doubleValue]);
    }
}

@end
