
#import "OSTExchangeCollectionViewCell.h"
// models
#import "OSTExchangeRate.h"

NSString * const kOSTPrefixPlus = @"+ ";
NSString * const kOSTPrefixMinus = @"- ";

NSString * const kOSTComma = @",";
NSString * const kOSTDot = @".";

NSUInteger const kOSTMaxValueSymbolsCount = 6;

@interface OSTExchangeCollectionViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

@property (strong, nonatomic) OSTExchangeValueBeginEditingCompletion valueBeginEditingCompletion;
@property (strong, nonatomic) OSTExchangeValueChangedCompletion valueChangedCompletion;
@property (nonatomic) BOOL isShowPlusPrefix;

@end

@implementation OSTExchangeCollectionViewCell

#pragma mark - View lifecycle -

- (void)awakeFromNib
{
    [super awakeFromNib];
    _valueTextField.delegate = self;
    [self setupTapGestureRecognizer];
}

- (void)dealloc
{
    self.valueBeginEditingCompletion = nil;
    self.valueChangedCompletion = nil;
}

#pragma mark - Public methods -

- (void)configureWithAccount:(double)account
                       value:(double)value
                    mainRate:(OSTExchangeRate *)mainRate
              additionalRate:(OSTExchangeRate *)additionalRate
                 isShowValue:(BOOL)isShowValue
 valueBeginEditingCompletion:(OSTExchangeValueBeginEditingCompletion)valueBeginEditingCompletion
      valueChangedCompletion:(OSTExchangeValueChangedCompletion)valueChangedCompletion
{
    self.valueBeginEditingCompletion = valueBeginEditingCompletion;
    self.valueChangedCompletion = valueChangedCompletion;
    self.isShowPlusPrefix = additionalRate ? YES : NO;
    
    _currencyLabel.text = [mainRate.currencyString uppercaseString];
    
    NSString *accountFormat = [NSString stringWithFormat:@"You have %@",
                               [self formatWithValue:account]];
    _accountLabel.text = [NSString stringWithFormat:accountFormat,
                          [mainRate currencySymbol], account];
    BOOL isEnoughMoney = additionalRate || account >= value;
    _accountLabel.textColor = isEnoughMoney ? [UIColor whiteColor] : [UIColor redColor];
    _accountLabel.alpha = isEnoughMoney ? .7f : 1.f;
    if (!isEnoughMoney) {
        [self animateAccountLabel];
    }
    
    _valueTextField.enabled = isShowValue;
    NSString *valuePrefix = _isShowPlusPrefix ? kOSTPrefixPlus : kOSTPrefixMinus;
    NSString *valueFormat = [self formatWithValue:value];
    _valueTextField.text = [NSString stringWithFormat:valueFormat,
                            valuePrefix, value];
    
    double mainRateDouble = [mainRate.rate doubleValue];
    if (additionalRate &&
        mainRateDouble != 0)
    {
        double rateDouble = [additionalRate.rate doubleValue] / mainRateDouble;
        NSString *helpFormat = [NSString stringWithFormat:@"%@1 = %@",
                                [mainRate currencySymbol],
                                [self formatWithValue:rateDouble]];
        _helpLabel.text = [NSString stringWithFormat:helpFormat,
                           [additionalRate currencySymbol],
                           rateDouble];
    }
    
    // some animations
    [UIView animateWithDuration:0.2
                     animations:^
     {
         _valueTextField.alpha = isShowValue ? 1.f : 0;
         _helpLabel.alpha = additionalRate ? .7f : 0;
     }];
}

#pragma mark - Setup methods -

- (void)setupTapGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleTapFrom:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (NSString *)formatWithValue:(double)value
{
    double valueIntegralPart;
    double valueFractionalPart = modf(value, &valueIntegralPart);
    return valueFractionalPart == 0 ? @"%@%.0f" : @"%@%.2f";
}

#pragma mark - Animations -

- (void)animateAccountLabel
{
    _accountLabel.transform = CGAffineTransformMakeScale(.4, .4);
    [UIView animateWithDuration:1.f
                          delay:0
         usingSpringWithDamping:.5
          initialSpringVelocity:6.f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^
     {
         _accountLabel.transform = CGAffineTransformIdentity;
     }
                     completion:nil];
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
    
    if (newStringWithoutPrefix.length > oldStringWithoutPrefix.length &&
        newStringWithoutPrefix.length > kOSTMaxValueSymbolsCount) {
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
    
    if ([text hasSuffix:kOSTDot]) {
        text = [text substringToIndex:text.length - 1];
    }
    
    NSCharacterSet *decimalDigitCharSet = [NSCharacterSet decimalDigitCharacterSet];
    NSString *valuePrefix = _isShowPlusPrefix ? kOSTPrefixPlus : kOSTPrefixMinus;
    // if new text doesn't contains digits then set 0
    if ([text rangeOfCharacterFromSet:decimalDigitCharSet].location == NSNotFound)
    {
        text = [NSString stringWithFormat:@"%@0", valuePrefix];
    }
    
    NSString *stringWithoutPrefix = [text substringFromIndex:kOSTPrefixPlus.length];
    double value = [stringWithoutPrefix doubleValue];
    NSString *valueFormat = [self formatWithValue:value];
    textField.text = [NSString stringWithFormat:valueFormat,
                            valuePrefix, value];
    textField.text = text;
    
    if (_valueChangedCompletion) {
        _valueChangedCompletion([stringWithoutPrefix doubleValue]);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_valueBeginEditingCompletion) {
        _valueBeginEditingCompletion();
    }
}

@end
