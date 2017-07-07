
#import "OSTExchangeCollectionViewCell.h"
// models
#import "OSTExchangeRate.h"

// constants
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
    [self defaultSetup];
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
    
    // configure currency label
    _currencyLabel.text = [mainRate.currencyString uppercaseString];
    
    // configure account label
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
    
    // configure value text field
    _valueTextField.enabled = isShowValue;
    [self refreshValueTextFieldWithValue:value];
    
    // configure help label
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

- (void)refreshValueTextFieldWithValue:(double)value
{
    NSString *valuePrefix = _isShowPlusPrefix ? kOSTPrefixPlus : kOSTPrefixMinus;
    NSString *valueFormat = [self formatWithValue:value];
    _valueTextField.text = [NSString stringWithFormat:valueFormat,
                            valuePrefix, value];
}

#pragma mark - Setup methods -

- (void)defaultSetup
{
    _valueTextField.delegate = self;
    [self setupTapGestureRecognizer];
}

- (void)setupTapGestureRecognizer
{
    // tap gesture recognizer to hide keyboard
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

- (BOOL)checkValueDecimalPartWithString:(NSString *)string
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
    // prevent prefix deletion
    if (![newString hasPrefix:valuePrefix]) {
        return NO;
    }
    
    // prevent editing with double decimal separator
    NSString *oldString = textField.text;
    if ([string isEqualToString:kOSTComma] &&
        ([oldString containsString:kOSTComma] ||
         [oldString containsString:kOSTDot])) {
        return NO;
    }
    
    // prevent editing with number or separator after 0
    NSString *oldStringWithoutPrefix = [oldString substringFromIndex:kOSTPrefixPlus.length];
    if ([oldStringWithoutPrefix isEqualToString:@"0"] &&
        ![string isEqualToString:kOSTComma] &&
        ![string isEqualToString:@""]) {
        return NO;
    }
    
    // prevent begin editing with decimal separator
    NSString *newStringWithoutPrefix = [newString substringFromIndex:kOSTPrefixPlus.length];
    if ([newStringWithoutPrefix hasPrefix:kOSTComma]) {
        return NO;
    }
    
    // limiting the maximum symbols count for beauty
    if (newStringWithoutPrefix.length > oldStringWithoutPrefix.length &&
        newStringWithoutPrefix.length > kOSTMaxValueSymbolsCount) {
        return NO;
    }
    
    // value decimal part lenght haven't to be greater than 2
    if (![self checkValueDecimalPartWithString:newStringWithoutPrefix
                                 withSeparator:kOSTDot] ||
        ![self checkValueDecimalPartWithString:newStringWithoutPrefix
                                 withSeparator:kOSTComma]) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text = textField.text;
    // replace comma separator to dot
    text = [text stringByReplacingOccurrencesOfString:kOSTComma
                                           withString:kOSTDot];
    
    // remove last symbol if it is separator
    if ([text hasSuffix:kOSTDot]) {
        text = [text substringToIndex:text.length - 1];
    }
    
    NSCharacterSet *decimalDigitCharSet = [NSCharacterSet decimalDigitCharacterSet];
    NSString *valuePrefix = _isShowPlusPrefix ? kOSTPrefixPlus : kOSTPrefixMinus;
    // if new text doesn't contains digits then set 0
    if ([text rangeOfCharacterFromSet:decimalDigitCharSet].location == NSNotFound) {
        text = [NSString stringWithFormat:@"%@0", valuePrefix];
    }
    
    // additional text formatting
    NSString *stringWithoutPrefix = [text substringFromIndex:kOSTPrefixPlus.length];
    [self refreshValueTextFieldWithValue:[stringWithoutPrefix doubleValue]];
    
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
