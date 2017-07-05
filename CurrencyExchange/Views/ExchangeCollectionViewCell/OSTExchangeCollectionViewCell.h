
typedef void (^OSTExchangeValueChangedCompletion)(double value);

@class OSTExchangeRate;

@interface OSTExchangeCollectionViewCell : UICollectionViewCell

/**
 Configure cell
 */
- (void)configureWithMainRate:(OSTExchangeRate *)mainRate
               additionalRate:(OSTExchangeRate *)additionalRate
                  isShowValue:(BOOL)isShowValue
       valueChangedCompletion:(OSTExchangeValueChangedCompletion)valueChangedCompletion;

@end
