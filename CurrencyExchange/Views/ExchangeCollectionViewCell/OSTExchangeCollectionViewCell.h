
typedef void (^OSTExchangeValueBeginEditingCompletion)();
typedef void (^OSTExchangeValueChangedCompletion)(double value);

@class OSTExchangeRate;

@interface OSTExchangeCollectionViewCell : UICollectionViewCell

/**
 Configure cell
 */
- (void)configureWithAccount:(double)account
                       value:(double)value
                    mainRate:(OSTExchangeRate *)mainRate
              additionalRate:(OSTExchangeRate *)additionalRate
                 isShowValue:(BOOL)isShowValue
 valueBeginEditingCompletion:(OSTExchangeValueBeginEditingCompletion)valueBeginEditingCompletion
      valueChangedCompletion:(OSTExchangeValueChangedCompletion)valueChangedCompletion;

@end
