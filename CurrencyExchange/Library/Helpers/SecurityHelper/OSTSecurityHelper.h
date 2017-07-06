
extern NSString * const kOSTSecureKeyEurAccount;
extern NSString * const kOSTSecureKeyUsdAccount;
extern NSString * const kOSTSecureKeyGbpAccount;

@protocol OSTSecurityHelper <NSObject>

/**
 Get secure string from the Keychain
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 Securely save row in the Keychain
 */
- (void)saveString:(NSString *)string
            forKey:(NSString *)key;

@end
