
typedef void (^OSTExchangeValueBeginEditingCompletion)();
typedef void (^OSTExchangeValueChangedCompletion)(double value);

@class OSTExchangeRate;

@interface OSTExchangeCollectionViewCell : UICollectionViewCell

/**
 Configure exchange collection view cell with data
 */
- (void)configureWithAccount:(double)account
                       value:(double)value
                    mainRate:(OSTExchangeRate *)mainRate
              additionalRate:(OSTExchangeRate *)additionalRate
                 isShowValue:(BOOL)isShowValue
 valueBeginEditingCompletion:(OSTExchangeValueBeginEditingCompletion)valueBeginEditingCompletion
      valueChangedCompletion:(OSTExchangeValueChangedCompletion)valueChangedCompletion;

@end
